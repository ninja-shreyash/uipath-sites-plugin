# Frontend Design Overrides

Use these rules when generating or modifying the UI for a UiPath coded app. They adapt the Claude frontend-design skill's styling intent for this plugin. They affect visual design only; they do not override `uipath-coded-apps` technical, auth, build, or deploy rules.

## Design direction

- Pick a clear visual direction before coding, based on the app's purpose, audience, and workflow.
- For operational UiPath apps, prefer a polished work-focused interface over a marketing page: dense but readable information, strong hierarchy, predictable navigation, and efficient repeated-use flows.
- Avoid generic AI-looking dashboards, placeholder cards, and copied admin templates.

## Typography and color

- Choose typography deliberately. Avoid default stacks like Arial, Inter, Roboto, and unconsidered system fonts when the project allows custom fonts.
- Use CSS variables for color, spacing, borders, and shadows.
- Commit to a cohesive palette with purposeful accents. Avoid purple-on-white defaults and timid evenly distributed colors.

## Layout and interaction

- Build the first screen around the actual product workflow, not an explanatory landing page.
- Use layout, spacing, and hierarchy to make the primary task obvious.
- Add motion only where it improves comprehension or polish, such as page-load reveals, hover states, or clear state transitions.
- Include loading, empty, error, selected, and disabled states for data-driven UI.

## Visual detail

- Add depth and atmosphere with restrained backgrounds, texture, borders, shadows, or structure when it supports the product tone.
- Keep UI text inside containers at all supported viewport sizes.
- Do not let decorative styling reduce scanability, accessibility, or operational clarity.
