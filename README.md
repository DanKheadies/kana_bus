# Kana Bus

Get on the Bus and lets learn some Kana.

## Conceptual Model

Bottom-Up

Busm > input (text and/or image) with it's associated translations

- A busm represents specific characters on your ride.
  - A "bus stop" where characters get on board.
  - Characters include specified language translations, e.g. [input], English, Japanese kana/kanji, Romanji.
- Pick up "Passengers" (characters) at a specific "Milestone" (snapshot of a place, idea, conversation, passage, etc.) and usher them into a "Bus Seat" (row on the bus).
  - (Old) Bus Seat vs Passengers vs Milestone vs Snapshot
  - (Old) What's the analogy? A busm is like a row on a bus memoralizing a scene out the the moment. You usher those new passengers--characters aka text--into a row on your Kana Bus.
  - (Old) Busm > a collection of characters you add to your route / trip

Bus Ride > List<Busm> + Context > a collection of busm based on a context

- A trip, schedule, journey and/or route can be planned or impromptu.
- Load the (infinite) bus back to front; recap the journey front to back
  - Ex: a quick reference / cheat sheet, lunch at a restuarant, a "conversation" with strangers, shop owner, etc., reading manga, prompts from a character in a game, and so on...
  - Could be word mining, could be a "here is my day," could be a cheat sheet, could be facilitating translating a game, book, etc.
- Contain optional information to help derive context, e.g. title, flags, etc.

[Need a good way to classify and organize Routes / Trips; Folders & Files] [Memory Palace] [Road Trip Maps] [Bus Schedule]

- There's a list of common phrases that I want to have readily on hand.
- I'm playing DWM and I want to add save the menu / UI words in one bucket, the dialogue as I'm progressing thru the game in another, a monster name and attack reference in another, etc.
- I want to search across all (or a specific set) of lists for a phrase.
- Crux: sounds like a general folder and file list / hierachy for now.
  - Minimum: each RTJ is captured by createdOn datetime
    - First input for added context (?)
  - More context: add a title, flag(s), or nested designation to give more of a...
    - Memory palace
    - Organizing my previous road trips and annotated maps
    - Call up my recent searches or saved places

## Credits:

Thank you Japan.

### Special Thanks:

- [Flutter](https://flutter.dev/)
- Stack Overflow
- GitHub
- Google
- Adobe

---

Compliments of DTFun LLC 2026
