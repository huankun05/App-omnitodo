# Design System Strategy: The Luminescent Canvas

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Digital Curator."** 

We are moving away from the cluttered, "utility-first" look of traditional productivity tools toward an editorial, high-end experience. The goal is to make task management feel like browsing a premium gallery. This system breaks the "template" aesthetic by utilizing aggressive whitespace, intentional asymmetry in layout, and a "Tonal Layering" philosophy that replaces rigid lines with soft, environmental depth. Every element should feel like it is floating in a light-filled room—intentional, calm, and premium.

## 2. Color Architecture
Our palette leverages a "Warm-Cool" tension. The warm background (#F7F7F9) provides a human, organic base, while the Klein Blue primary accents provide digital authority and precision.

### The "No-Line" Rule

**Borders are strictly prohibited for sectioning.** To define boundaries between content areas, you must use background color shifts. For example, a `surface-container-low` section should sit directly on a `surface` background. If you feel the need for a line, you haven't used enough whitespace or tonal contrast.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers—like stacked sheets of fine paper.
- **Base Layer:** `surface` (#F9F9FB) – The infinite canvas.
- **Section Layer:** `surface-container-low` (#F3F3F5) – Used for grouping large content blocks.
- **Interaction Layer:** `surface-container-lowest` (#FFFFFF) – The primary "Card" surface. 

### The "Glass & Gradient" Rule
To elevate the "out-of-the-box" look, use **Glassmorphism** for floating elements (like Navigation Bars or Quick-Action Buttons). Apply `surface` colors at 80% opacity with a `20px` backdrop-blur. 
- **Signature Texture:** For primary CTAs, use a subtle linear gradient from `primary` (#004AC6) to `primary-container` (#2563EB) at a 135° angle. This adds "soul" and dimension that flat hex codes lack.

## 3. Typography
The typography is the "Editorial" engine of this system. We pair the geometric stability of **Manrope** for headers with the high-legibility of **Inter** for utility.

- **Display & Headline (Manrope):** Use `w800` (ExtraBold) for `headline-lg` and `headline-md`. This heavy weight creates an authoritative, "magazine-style" anchor for the page.
- **Title & Body (Inter):** These are the workhorses. Use `title-lg` for task headers to ensure they feel distinct from metadata.
- **The Hierarchy Strategy:** Use extreme scale contrast. A `display-lg` page title should feel massive compared to a `label-sm` timestamp. This "Big & Small" approach creates a signature, modern rhythm that feels custom-designed.

## 4. Elevation & Depth
In this system, depth is environmental, not structural.

- **The Layering Principle:** Achieve lift by stacking. A `surface-container-lowest` card placed on a `surface-container-high` background creates a natural visual "pop" without a single shadow being cast.
- **Ambient Shadows:** When a floating effect is required (e.g., a "Create Task" modal), use the following: `Box-shadow: 0px 8px 24px rgba(30, 41, 59, 0.04)`. Note the use of the `primary-text` color (#1E293B) at low opacity instead of pure black; this makes the shadow feel like a natural reflection of the UI.
- **The "Ghost Border" Fallback:** If a border is required for accessibility, use `outline-variant` at **15% opacity**. Never use 100% opaque borders.
- **Motion-Depth:** As users scroll, use CSS `backdrop-filter: blur(10px)` on header containers to allow the "hint" of tasks below to bleed through, maintaining a sense of spatial awareness.

## 5. Components

### Buttons
- **Primary:** Rounded `full` (pill-shaped). Gradient fill (Klein Blue). White text.
- **Secondary:** Surface-container-high background with `on-surface` text. No border.
- **Tertiary:** Pure ghost style. Bold text in `primary` color, no background until hover.

### Task Cards & Lists
- **The Divider Ban:** Do not use 1px lines between tasks. Instead, use a `12px` vertical gap.
- **Status Indication:** Use the `secondary` (Vibrant Orange) token sparingly for high-priority highlights or "Overdue" status. It should act as a "spark" on the cool blue/grey canvas.

### Input Fields
- **State Transition:** Default state is a subtle `surface-container-high` fill. On focus, the background shifts to `surface-container-lowest` (pure white) with a soft `primary` ambient shadow. This "glow" indicates the field is active without needing a heavy blue border.

### Interactive "Micro-Chips"
- Use for categories (e.g., "Work," "Personal"). These should use `surface-variant` backgrounds with `label-md` typography. When selected, they transition to `primary` with a scale-up animation (1.05x).

## 6. Do’s and Don'ts

### Do:
- **Do** use `2rem` (32px) or more for page margins. Spaciousness is a feature, not a waste of space.
- **Do** use `w800` weight for main page titles to create an editorial feel.
- **Do** align items to a soft 8px grid, but allow for asymmetrical "breaks"—like a floating action button offset slightly from the standard grid.

### Don't:
- **Don't** use 1px solid grey borders. It breaks the "Luminescent" feel and makes the app look like a generic template.
- **Don't** use pure black for text. Use `on-surface` (#1E293B) to keep the contrast high but the tone sophisticated.
- **Don't** crowd the interface. If you can't fit it with `1.5rem` of padding, it belongs in a sub-menu or a different view.