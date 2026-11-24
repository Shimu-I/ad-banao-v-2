# ADR 0005: Vite single-page app for the frontend

Status: accepted (2026-11-18)

## Context
The signed-in app does not need server rendering. The public home page needs good search visibility. Two servers (Next.js plus FastAPI) add moving parts.

## Decision
Build the frontend as a React and TypeScript single-page app with Vite. Pre-render the home page at build time.

## Consequences
Simple static hosting on free tiers. If marketing pages grow, split them into a separate Astro or Next.js site later.
