## Common Errors to Avoid


# GitHub Copilot Instructions

## 1. Understand Before Changing
- Review the relevant existing code before making changes.
- Follow existing project patterns, architecture, naming conventions, and folder structure.
- Do not introduce a new approach when an established project pattern already exists.

## 2. Make Minimal Changes
- Make only the changes necessary to complete the requested task.
- Do not refactor, rename, reformat, or modify unrelated code unless explicitly requested.
- Avoid unnecessary dependencies or architectural changes.

## 3. Do Not Break Existing Functionality
- Preserve existing behavior unless the task specifically requires changing it.
- Consider downstream dependencies and side effects before modifying shared code.
- Maintain backward compatibility whenever practical.

## 4. Never Hardcode Sensitive or Environment-Specific Values
- Never hardcode passwords, API keys, tokens, credentials, connection strings, or secrets.
- Use environment variables or the project's existing configuration system.
- Do not commit secrets to source control.

## 5. Validate External Input
- Treat user input, URL parameters, form data, API responses, and external data as untrusted.
- Validate and sanitize input appropriately.
- Use parameterized database queries and avoid constructing SQL from raw input.

## 6. Handle Errors Properly
- Anticipate common failure conditions.
- Do not silently swallow exceptions or errors.
- Log useful diagnostic information without exposing sensitive information to users or logs.

## 7. Keep Code Simple
- Prefer clear, readable, maintainable code over clever or overly complex solutions.
- Avoid unnecessary abstractions.
- Reuse existing functions, utilities, and components instead of duplicating functionality.

## 8. Check Before Creating
- Search the existing codebase before creating a new function, component, utility, configuration, or dependency.
- Extend or reuse existing functionality when appropriate.
- Avoid duplicate implementations.

## 9. Verify Changes
- Review modified code for syntax errors, logic errors, edge cases, and unintended side effects.
- Run or update relevant tests when available.
- Verify that the requested functionality works before considering the task complete.

## 10. Communicate Important Changes
- Clearly identify assumptions, limitations, migrations, configuration changes, or potential breaking changes.
- Do not hide unresolved problems with temporary workarounds.
- If uncertain about a requirement that could materially affect the implementation, ask before making a destructive or difficult-to-reverse change.

##Final Check

Before completing any coding task, confirm:

Did I understand the existing implementation?

Did I change only what was necessary?

Did I reuse existing code where appropriate?

Did I preserve existing functionality?

Did I avoid introducing security vulnerabilities?

Did I avoid hardcoded secrets or environment-specific values?

Did I handle errors and edge cases appropriately?

Did I avoid unnecessary complexity?

Did I verify the changes I made?

Did I avoid making unsupported assumptions?



##Lucee
Escape the # with double ## in Lucee cfm files. This prevents the # from being interpreted as the start of a variable or expression.