# Hour-Logger

I got heavily inspired by my friend who did [what this redditor did](https://www.reddit.com/r/dataisbeautiful/comments/101hvnv/oc_i_tracked_every_hour_of_my_life_for_5_years/). In fact, I will heavily use [OP's template](https://docs.google.com/spreadsheets/d/1W79a98wLeuMjDbJuy0IYDeQYZSVaWjTUCPUpXj24MHs/edit?usp=sharing) posted in their thread as reference.

Idea on what I want: 
- A front end gui for the app (unsure if will be desktop, web, or mobile app)
  - due to wanting flexability, I will most likly go for JS/TS. Since it can be used in Proton, React, or React native for their respective platforms listed above
  - I shall, however, consider other options since personally I want to try a less familiar language as a learning experience, there are lots of things for me to consider on what I am doing on this project
      - ideally, I would avoid C# since I am using it for work and I want to use something I am less familiar
- each category having their own sub category
- the ability for users to add their own categories, subcategories
- a way to import and export the data
  - too keep it simple I might just save it on a google sheet or excel sheet like as a database for the time being to keep it super simple. Also considering its a side project made mostly for my own self, it does not make sense to use a database

## Language Choice
Requirements:
- Cross Platform 
  - I just want the flexability to easiy switch platforms by only changing GUI aspects rather than logical aspects of the code
- Less familiar language
  - I want something that I am less familiar with more as a challenge and to learn a "new" language
- Good support
  - If this ends up being something I use day to day (which I might but I dont know if I will) it needs to be a language that is still being used
  - This also means that documentation is plentiful or enouph to get work done and well written

Language Choice: Dart *May change in the future*

Why not other common languages
- I am decently familiar with Python and JS to where I personally dont want to consider those two as options even though I have not made my own side projects with them
- C/C++ ... I want to keep my sanity
- C# I use for work so I personally dont want to use it for this
- Java just feels verbose and clunky from the short time I have used it
- Other JVMs: personally I do not know how supported the other JVM languages are... I bet they are fine. In fact, I personally wanted to use Scala; however, that is due to me liking the language the few times I have used in class

I personally feel like Dart fits best with my requirements and therefore decided that. Its cross platform capabilities is one of its selling points. It also a language I have never used before in my life. Not even a hello world. This is unlike the choices above. Is dart the best choice... most certainly not. I feel like a sane person would choose JS since it is used every where, by many companies, etc.

### Framework Choice

The plan is to make it cross platform. Realistically this wont me the code can just be used on all platforms since there are different interfaces, I hope to make the logic easily transferable and extendable.

So due to what was stated above, a quick google search and I've decided to use the flutter framework to create cross platform apps with my code.