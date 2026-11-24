# ADR 0006: Archive, do not delete

Status: accepted (2026-11-18)

## Context
Ads reference products, and products reference brands. Deleting breaks history and audit.

## Decision
Brands and products are archived and can be restored. Foreign keys use RESTRICT.

## Consequences
A real data-deletion feature (privacy request) must be designed separately before public launch.
