# Frontend Design Overrides

Use these rules when creating or materially changing the UI of a UiPath coded app. These rules affect presentation and UX only; they do not override the `uipath-coded-apps` skill's technical, auth, build, or deployment instructions.

## Visual direction

- Choose a clear visual direction before coding: operational console, field-service cockpit, analyst workspace, executive review, or another concrete product mood that matches the user's request.
- Avoid generic placeholder dashboards, interchangeable cards, and filler charts.
- The first screen should show the actual workflow the user asked for, not a marketing page or setup explanation.
- Use concrete domain copy in headings, labels, empty states, and button text.

## Layout and interaction

- Design the primary workflow first, then add supporting panels, filters, details, or actions only when they help that workflow.
- Include real UI states: loading, empty, error, selected, disabled, and success states where relevant.
- Make dense enterprise data scannable with clear grouping, hierarchy, alignment, and affordances.
- Do not add speculative flows such as auth screens, settings, storage, upload, or admin areas unless the user requested them.

## Styling

- Use deliberate typography and palette choices. Avoid default-looking stacks such as Inter, Roboto, Arial, or plain system fonts when the project allows custom styling.
- Define CSS variables for color, typography, spacing, radius, shadow, and motion decisions.
- Use contrast, spacing, and type scale to establish hierarchy instead of relying only on card borders.
- Prefer a polished work-focused UI over decorative novelty.
- Use motion sparingly for comprehension, such as staged entry, status changes, or panel transitions.

## Quality bar

- The UI should look like a purposeful product screen at first render.
- Keep the implementation simple enough to maintain; do not introduce animation or component abstractions that make the coded app harder to validate.
- Before calling the work complete, verify the app builds and the initial viewport matches the requested workflow.
