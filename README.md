# CLI Journal app made in Ruby
## A small journal app, my first Ruby creation. 

### What is it?
- Allows users to write entries with optional titles
- The program will auto create a txt file with the date of the entry when it's closed
- Entries can be edited or removed
- Style inspired by Alien Isolation's terminals (Don't worry, no evil alien will chase you... yet. Maybe I'll add that feature in the future)
- Added export support for PDF, Markdown, and Plain Text!
- Users can now select which journal to load or create. data is stored locally. 

## This project is very small, but I have plans for it

### What I'd like to add
- Probably should be able to choose the name of the file you're saving ✅ Done!
- Testing manually proved difficult as the program grows. I must learn and add tests before anything else.(at testing framework perhaps that can be added to as features as added)
- Swap journal in the loop menu
- Choose export filename ("Save As" dialog when exporting)
- I want this to be useful for everyone, so some user interface, be it TUI or GUI (but it'll still look like Alien terminals)
- Save in different file formats ✅ Done!
- Encryption (because some thoughts need protecting from the Nostromo's crew)
- Evil Alien showing up now and then (maybe allow the user to turn that off)
- I'm open to suggestions!

## Installing

1. Git clone this repo:
```bash
git clone https://github.com/Redsskull/journal
cd journal
```

2. Configure Bundler:
```bash
bundle config set --local path 'vendor/bundle'
```

3. Install dependencies:
```bash
bundle install
```

4. Run the app:
```bash
ruby main.rb
```

**This app requires Ruby installed**
