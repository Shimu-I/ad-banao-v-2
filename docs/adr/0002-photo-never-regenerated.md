# ADR 0002: The original product photo is never regenerated

Status: accepted (2026-11-18)

## Context
AI image tools can change a product's look or packaging, which is the main trust problem this product exists to solve.

## Decision
The uploaded photo is stored byte for byte under its SHA-256 name and placed untouched in ads. Integrity is checked by comparing hashes, not by image similarity.

## Consequences
Far more reliable than similarity scores. No AI-generated product imagery in version 1.0. Optional generated backgrounds stay on the later list.
