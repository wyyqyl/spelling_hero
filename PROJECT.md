### **Project Name:** `SpellingHero`

---

### **1. Tech Stack & Dependencies**

Tell the AI to use these specific packages to ensure the app is robust and child-friendly.

* **Core Framework:** Flutter (Latest Stable)
* **State Management:** `flutter_riverpod` (Great for managing the state of the dictation session, timer, and lists).
* **Local Database:** `drift` (To save the dictation lists and history locally so the child can practice offline).
* **AI/OCR (Text Extraction):** `google_mlkit_text_recognition` (On-device, fast, free, and privacy-friendly for scanning homework).
* **Text-to-Speech:** `flutter_tts` (To read the words/sentences aloud).
* **Audio Effects:** `audioplayers` (For "Success!" ding, "Try Again" boop, and background ambience).
* **Animations:** `lottie` (For high-quality feedback animations like confetti, jumping stars, or sad clouds).
* **UI/Styling:** `google_fonts` (Use a font like *Comic Neue*, *Fredoka One*, or *Nunito* for friendliness).

---

### **2. UI/UX "Pro Max" Design Guidelines**

Instruct the AI to follow these design principles:

* **Color Palette:** Use a "Candy Store" palette.
* Primary: Soft Blue (#4facfe) or Mint Green (#00f260).
* Action Buttons: Bright Orange (#f093fb) or Yellow (#f5576c) – hard to miss.
* Success: Vibrant Green.
* Error: Soft Red (Don't use harsh red; use a "Oops" pink/orange).


* **Typography:** Large, rounded sans-serif fonts. Minimum font size for inputs should be 24sp.
* **Input UX:**
* Instead of a standard keyboard popping up and obscuring the view, consider a **Custom On-Screen Keyboard** or **Letter Blocks** that the child drags or taps.
* *Self-Correction:* If the child types a wrong letter, shake the block gently instead of a jarring error message.


* **Feedback:** "Juicy" UI. Buttons should squish when tapped (scale animation). Success should trigger particle explosions (confetti).

---

### **3. Detailed Feature Breakdown (The Prompt for the AI)**

#### **Phase 1: Data Model & Storage**

* **Entity:** `DictationList` (id, name, dateCreated, themeColor).
* **Entity:** `DictationItem` (id, text, audioUrl (optional), isSentence).
* **Storage:** Create a repository pattern to save/load these lists.

#### **Phase 2: The Main Page (The "Bookshelf")**

* **Layout:** A grid or list of "Workbooks" (the dictation lists). Each item looks like a colorful book or card.
* **Floating Action Button (FAB):** A massive "+" button. When tapped, show two options with icons: "Camera" (Scan) and "Pencil" (Type).
* **Actions:** Long-press a list to Edit/Delete. Tap to open the "Mission Briefing" (Detail View).

#### **Phase 3: The Scanner (OCR)**

* **Functionality:** Open camera -> Capture -> Crop.
* **Processing:** Use ML Kit to extract text.
* **Review Screen:** Show the extracted text as a list of editable bubbles.
* *AI Logic:* The AI should try to split lines into separate items automatically.
* *User Control:* Allow user to tap an item to edit spelling or delete garbage text (like page numbers).
* *Save:* Button to "Create Workbook".



#### **Phase 4: Dictation Logic (The Core)**

This is the most complex part. The screen needs 3 distinct zones:

1. **Top Zone (Progress):**
* **Progress Bar:** A visual bar (e.g., a caterpillar moving across a leaf) filling up as they go.
* **Counter:** "3 / 10" (Big text).
* **Timer:** A friendly clock icon. Don't make it count down (stressful); count *up* to show how fast they were later.


2. **Middle Zone (Interaction):**
* **The Speaker Button:** Huge button in the center. Tapping it plays the TTS.
* **The Input Field:**
* **For Words:** Display empty squares `[ ] [ ] [ ]` representing the number of letters in the word. This gives the child a hint about length.
* **For Sentences:** A large, multi-line rounded text area with a blinking cursor.




3. **Bottom Zone (Controls):**
* **Submit Button:** A big "Check" mark.
* **Skip/Hint:** A smaller "?" button (maybe reveals the first letter).



#### **Phase 5: Practice vs. Quiz Modes**

* **Practice Mode (Immediate Feedback):**
* **Correct:**
* Sound: "Ding!" + "Yay!"
* Visual: Lottie animation (Star jumps out).
* Action: Auto-advance to next after 1.5 seconds.


* **Incorrect:**
* Sound: "Boop" (gentle thud).
* Visual: The input box shakes left-to-right.
* UI: Show "Try Again" button (clears input) and "Show Answer" button (fills text in green, then Next).




* **Quiz Mode (Silent Test):**
* **Logic:** User types -> Tap Submit -> App saves answer internally -> Immediately goes to next question.
* **Visual:** No green/red indication. Just a "Saved" animation (e.g., paper flying into a folder).



#### **Phase 6: The Summary Page (The "Report Card")**

* **Header:** "Great Job!" or "Keep Practicing!" based on score.
* **Score:** Big circle with "8/10".
* **The List:**
* Scrollable list of all items.
* **Correct Items:** Green checkmark.
* **Wrong Items:** Red X. Show "You wrote: [wrong]" vs "Correct: [right]".


* **Action:** A button "Practice Mistakes" that immediately starts a new Practice session with *only* the wrong words.
