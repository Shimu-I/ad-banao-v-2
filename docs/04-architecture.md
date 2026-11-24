# System architecture

How the pieces fit together. All diagrams are Mermaid and render on GitHub.

## System context

```mermaid
flowchart TB
    User([Business user])
    Reviewer([Reviewer or approver])
    subgraph AdBanao["AdBanao"]
        Web[Web app]
        API[API server]
    end
    LLM[(Gemini and Groq)]
    DB[(PostgreSQL)]
    Store[(Object storage)]
    Auth[Auth provider]
    Err[Error tracking]

    User --> Web
    Reviewer --> Web
    Web --> API
    API --> LLM
    API --> DB
    API --> Store
    API --> Auth
    API --> Err
```

## Containers and components

```mermaid
flowchart LR
    subgraph Browser["Browser: React and TypeScript"]
        Home[Home page]
        Wizard[Details form]
        Editor[Ad editor, Konva]
        Panel[Check panel]
        Client[Generated API client]
    end
    subgraph Server["API server: FastAPI"]
        Routers[Routers /api/v1]
        Services[Services: profiles, generation, ads, verification]
        Grounding[Grounding and fact checker]
        Gen[Generation: provider layer]
        Render[Renderer: Pillow]
        Verify[Verification engine]
        Repo[Repositories: SQLAlchemy]
        StoreI[Storage interface]
    end
    subgraph Verifiers["Verifiers"]
        V1[Price and details]
        V2[OCR]
        V3[Claims]
        V4[Brand]
        V5[Photo integrity]
    end

    Client --> Routers
    Routers --> Services
    Services --> Grounding
    Services --> Gen
    Services --> Render
    Services --> Verify
    Services --> Repo
    Services --> StoreI
    Verify --> V1
    Verify --> V2
    Verify --> V3
    Verify --> V4
    Verify --> V5
    Gen --> Grounding
```

**Layering rule:** routers only translate HTTP. Services hold the logic. Pure modules (normalisation, grounding, scene schema, verifiers) import nothing from the web or database layers, so they can be tested anywhere. This is how 245 tests already run without a database.

## The main flow: from form to approved ad

```mermaid
sequenceDiagram
    actor U as User
    participant W as Web app
    participant A as API
    participant G as Generation and fact check
    participant R as Renderer
    participant V as Verification
    participant S as Storage and DB

    U->>W: Fill in the one form and upload photo
    W->>A: Save product (validated and normalised)
    A->>S: Store original photo (SHA-256 name)
    U->>W: Click Generate
    W->>A: Generate text
    A->>G: Prompt with facts only
    G-->>A: Description, headline, tagline, button (or basic text)
    A->>A: Fact check rejects invented numbers and claims
    A->>R: Build scene layers and render image
    R->>S: Save scene version 1 and image
    A->>V: Run all checks on scene and image
    V-->>A: Report: Verified, Issue found or Cannot verify
    A-->>W: Ad, text and report
    U->>W: Edit the ad (move, text, color, photo)
    W->>A: Patch layers
    A->>S: Save new version
    A->>R: Re-render
    A->>V: Re-check (approval cleared)
    U->>W: Approve
    W->>A: Approve version N
    A->>S: Store approved content hash
    A-->>W: Export image and report
```

## Ad status and approval rules

```mermaid
stateDiagram-v2
    [*] --> draft: ad created
    draft --> needs_fix: checks find issues
    draft --> verified: all checks pass
    needs_fix --> verified: issues fixed and re-checked
    verified --> approved: human approves
    approved --> draft: any edit (approval cancelled)
    verified --> draft: any edit
    needs_fix --> draft: any edit
    approved --> approved: undo to identical content (hash matches)
    approved --> [*]: exported
```

An approval is valid only while the ad's current content hash equals the approved content hash. Undo back to identical content makes the old approval valid again. Anything else does not.

## Verification pipeline

```mermaid
flowchart TB
    In[Ad version: scene layers and rendered image] --> P[Price and details]
    In --> O[OCR on rendered image]
    In --> C[Unsupported claims]
    In --> B[Brand rules]
    In --> I[Photo integrity]
    P --> Agg[Aggregate: worst result wins]
    O --> Agg
    C --> Agg
    B --> Agg
    I --> Agg
    Agg --> R{Overall}
    R -->|any critical issue| Fix[Issue found: show reason and fix]
    R -->|nothing checkable| CV[Cannot verify]
    R -->|all verified| OK[Verified]
    Fix --> Edit[User edits or applies one-click fix]
    Edit --> In
```

Rules every check follows:

1. Returns exactly one of `verified`, `issue_found`, `cannot_verify`.
2. Never returns `verified` without evidence. Empty or unreadable input gives `cannot_verify`.
3. Includes a plain-language reason, a severity (critical, warning, suggestion), and evidence (expected value and found value).
4. An empty report is `cannot_verify`, never "verified".

## Deployment

```mermaid
flowchart LR
    Dev[Developer on Linux: venv or Docker Compose] -->|push branch| GH[GitHub]
    GH -->|pull request| CI[GitHub Actions: lint, types, tests, build]
    CI -->|merge to main| Staging
    subgraph Staging["Staging (free tier)"]
        FE[Frontend: Vercel or Netlify]
        BE[Backend: Render or Fly.io]
        PG[(Postgres: Supabase or Neon)]
        OBJ[(Object storage)]
    end
    FE --> BE
    BE --> PG
    BE --> OBJ
    CI -->|tag v1.x.y| Prod[Production]
```
