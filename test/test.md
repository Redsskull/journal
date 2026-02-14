# My testing philosophy on this project

## So moment of truth

### I never wrote every line of testing myself until today

I did in bootcamp, maybe once per project. I asked AI to do it. This projects whole purpose is to code properly, like the old days(I debugged this thing with a ruler line by line, really) and so I set out to write the test like that too. It was a day of difficulty to grasp(and I have not dared tried BDD!) but when i got it, I wrote tests, and have many failures such as accessing the wrong part of an array, forgetting to delete files I was creating(I realized unless I mock in a test, a test will do the real thing! a lesson for C too, clean up memory as well as files, clean up after you!(even with garbage collecton, look). I also learned if I read the test result paitnetly..I will see what is wrong. I had a full array returned instead of a string, or even a memory pointer..in Ruby. It allowed me to troubeshoot, read google results, just figure out the problem. 

When writing a program, I learned I can write a feature that runs in two files. Main function calls it's helper function that calls a class method. In the moment it all works, but sometimes I don't even know how it all worked..exactly. The test taught me that. testing as I go before I write THREE functions(test the first) one will improve that too. 

I wrote them after I had quite the functionality, and I learned my favorite way to write tests is feature by feature, slowly as I go, which now will be done moving forward, but I won't write tests for every feature I already wrote, as it works(unless of course a bug is reported/discovered). I understand testing deeply now, and appreciate it much more. The current tests in serve to teach me that lesson, and I wanted to document it.

Well, this may not be the most technical document but I think it get's the poit across!
