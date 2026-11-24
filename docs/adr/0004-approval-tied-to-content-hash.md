# ADR 0004: Approval is tied to a content hash

Status: accepted (2026-11-18)

## Context
An ad that is edited after approval must not be exportable as approved.

## Decision
Approval stores the hash of the approved content. It is valid only while the current content hash is identical. Any edit invalidates it. Undo back to identical content makes it valid again.

## Consequences
Needs a deterministic content hash over the scene and text (goal A1). Tests must prove an edited ad cannot be exported as approved.
