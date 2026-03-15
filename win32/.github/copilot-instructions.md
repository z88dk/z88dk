# Copilot Instructions

## Project Guidelines
- When reporting parse errors without a direct token location, prefer using the current token context (for example 'after token ...') instead of error(SourceLoc(), ...).