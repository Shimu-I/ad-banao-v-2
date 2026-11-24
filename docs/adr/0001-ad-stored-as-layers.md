# ADR 0001: The ad is stored as layers, and the server render is final

Status: accepted (2026-11-18)

## Context
The ad must be editable after it is generated, and it must be checkable. Reading only a finished picture makes checks unreliable.

## Decision
Store each ad as a scene: a list of layers (photo, text, button, logo) with positions and styles. The server renders the scene to an image with Pillow. That server image is the one verified and exported.

## Consequences
Checks know exactly which text, price and photo an ad holds. The browser editor preview can differ slightly, so a final server render is shown before approval. Scenes carry a schema_version so old ads can be migrated.
