# ADR 0003: Every check returns Verified, Issue found or Cannot verify

Status: accepted (2026-11-18)

## Context
A check that guesses will sometimes say Verified when it should not, and users will trust it.

## Decision
Each check returns exactly one of three results, with a reason, a severity and evidence. No evidence means Cannot verify. An empty report is Cannot verify. The overall result is the worst individual result.

## Consequences
Honest uncertainty is part of the product. User-facing wording is 'no issues detected', never 'guaranteed'.
