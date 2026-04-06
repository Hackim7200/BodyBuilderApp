# Design System Specification: High-Performance Monochromatic Editorial

## 1. Overview & Creative North Star
**Creative North Star: The Kinetic Archive**
This design system moves beyond the "utility app" aesthetic to create a high-end, editorial experience for the elite athlete. It is a digital sanctuary for performance—clinical, precise, yet deeply sophisticated. We reject the "template" look of standard workout trackers by embracing **The Kinetic Archive**—a layout style characterized by bold typographic scales, intentional asymmetry, and a departure from traditional structural lines.

By utilizing high-contrast monochromatic shifts and layered tonal depth, we create a UI that feels like a premium fitness journal. The interface does not just "display" data; it "archives" progress with the authority of a high-fashion editorial spread.

---

## 2. Colors & Tonal Architecture
The palette is strictly monochromatic, using the interplay of light and shadow to define function. 

### The Palette
- **Primary (Core Action):** `#000000` (The anchor of the system)
- **Surface (Foundation):** `#F9F9F9` (The "paper" on which we build)
- **Tertiary (Neutral/Muted):** `#3A3C3C` (For secondary information)
- **Status (Feedback Only):** 
    - *Success:* `#2E7D32` (Progressive growth)
    - *Error:* `#BA1A1A` (Stasis/Risk)

### The "No-Line" Rule
Standard 1px borders are prohibited for sectioning. We define boundaries through **background color shifts**. 
- A workout card should not have a border; it should be a `surface_container_lowest` (#FFFFFF) block sitting on a `surface` (#F9F9F9) background.
- Use the **Spacing Scale** (specifically `spacing-6` or `spacing-8`) to create "voids" that act as invisible dividers.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of semi-translucent materials.
- **Level 1 (Base):** `surface` (#F9F9F9)
- **Level 2 (In-Page Content):** `surface_container` (#EEEEEE)
- **Level 3 (Interactive Elements/Cards):** `surface_container_lowest` (#FFFFFF)
- **Glassmorphism:** For floating headers or navigation bars, use `surface` at 80% opacity with a `20px` backdrop-blur to create a "frosted glass" effect that allows the workout data to scroll softly beneath.

---

## 3. Typography: The Editorial Voice
We use **Inter** as our typographic engine. Hierarchy is achieved through extreme weight variance rather than color.

| Role | Token | Weight | Case | Letter Spacing |
| :--- | :--- | :--- | :--- | :--- |
| **Hero Data** | `display-lg` | 800 (ExtraBold) | Default | -0.04em |
| **Section Header** | `headline-sm` | 700 (Bold) | Uppercase | 0.05em |
| **Secondary Info** | `title-sm` | 500 (Medium) | Default | 0 |
| **Utility/Labels** | `label-sm` | 600 (SemiBold) | Uppercase | 0.1em |

**Editorial Strategy:** Use `display-lg` for primary metrics (e.g., total weight lifted) to create a "brutalist" focal point. Contrast this with `label-sm` in uppercase for metadata to mimic a scientific lab report.

---

## 4. Elevation & Depth
We eschew traditional drop shadows for **Tonal Layering**.

- **The Layering Principle:** Depth is achieved by "stacking." A `surface_container_high` (#E8E8E8) element on top of a `surface` background creates a natural recession without visual clutter.
- **Ambient Shadows:** Only use shadows for "active" floating elements (like a FAB). Use the `on_surface` color at 4% opacity with a blur of `24px` to mimic soft, overhead gym lighting.
- **The "Ghost Border" Fallback:** If a distinction is absolutely required for accessibility, use the `outline_variant` (#C6C6C6) at **15% opacity**. This creates a suggestion of a container rather than a hard cage.

---

## 5. Components
Our components are flat, sharp, and intentional.

### Buttons
- **Primary:** `primary` (#000000) background with `on_primary` (#E2E2E2) text. Square-ish corners (`rounded-sm`). No shadow.
- **Secondary:** `surface_container_highest` (#E2E2E2) background. Bold text.
- **Tertiary:** Transparent background, `label-md` uppercase text with a `spacing-px` underline.

### Cards & Data Lists
- **Rule:** No dividers. 
- **Structure:** Use `spacing-4` (1.4rem) padding. Group related data (Sets/Reps) within a `surface_container_low` (#F3F3F3) block to separate it from the rest of the workout.
- **Interaction:** On press, the card should scale down slightly (98%) and shift to `surface_dim` (#DADADA) rather than showing a "ripple."

### Performance Inputs
- **Text Inputs:** Bottom-border only (`outline` #777777). Focus state shifts the border to `primary` (#000000) and increases weight to 2px. 
- **Selection Chips:** Use `rounded-full`. Unselected: `surface_container`. Selected: `primary`.

### Specialized Gym Components
- **The Progress Rail:** A thin 2px horizontal bar using `surface_container_highest`. The "filled" portion uses `primary`.
- **The Intensity Pulse:** A small dot using `error` (#BA1A1A) for high-intensity zones, placed next to heart rate or RPE data.

---

## 6. Do's and Don'ts

### Do
- **Do** use aggressive white space. If a screen feels "full," remove a container and use a `spacing-10` gap instead.
- **Do** use `display-lg` for numbers. In a fitness app, the data is the art.
- **Do** rely on typography weight (Thin vs. ExtraBold) to create hierarchy.

### Don't
- **Don't** use 1px solid borders to box in content. It creates "visual noise" that distracts the athlete.
- **Don't** use standard blue for links. Everything is black, white, or grey unless it is a critical safety alert.
- **Don't** use rounded corners larger than `rounded-lg` (1rem). We want the system to feel architectural and precise, not "bubbly" or "friendly."

---

## 7. Signature Textures
To add "soul" to the clinical aesthetic, apply a subtle **Linear Gradient** to the Primary CTA buttons:
- **Gradient:** `primary` (#000000) to `primary_container` (#3B3B3B) at a 135-degree angle. This provides a tactile, carbon-fiber-like depth that feels premium and high-performance.