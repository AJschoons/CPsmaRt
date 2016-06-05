![logo 1x](https://cloud.githubusercontent.com/assets/7013639/13204052/a69951ca-d893-11e5-93e9-8c43f5fefa1a.png)

Lifesaving smartphone and smartwatch app that helps rescuers keep a steady rate for CPR with sound and vibration. Repository for the iPhone and Apple Watch app

Winner of runner-up for best iOS app from Apple at Hack Illinois 2016.

Note: Please don't consider the quality of this code as representive of my work, as of right now this was scrapped together at Hack Illinois 2016 over the period of 36 hours, and my first Apple Watch app. 

##Inspiration
CPsmaRt was inspired by Reddit. A paramedic specializing in high performance CPR made a request for an Android app to help perform CPR. This app was to have flexible beats per minute and audio warnings for when the CPR is over, or when a breath is coming up.

We decided to make a simple version of that request, except to bring it to iOS, Android, Apple Watch, and Android Wear.

(https://www.reddit.com/r/androiddev/comments/41g1sd/seeking_advice/)

##What it does
CPsmaRt utilizes smart phones and smart watches to help people perform CPR in emergency situations. By starting a CPR session, the user is periodically prompted to give compressions with haptic feedback, animations, and beeps. After 30 compressions the user is then told to give 2 rescue breaths, which is signified by distinct vibrations and a voice prompt. The cycle then repeats. These CPR sessions can be started on either a smart phone or smart watch. When a CPR session is started on the smart watch the user gets the most benefit. This is because they get haptic feedback and visual cues on their wrist, and then louder audio cues on their phone. Available on iOS, Apple Watch, Android, and Android Wear.

##How we built it
CPsmaRt is built natively on iOS and Android. The iOS version utilizes WatchOS2, while the Android version utilizes Android Wear.

##Challenges we ran into
Since WatchOS2 and Android Wear are both fairly new, it was difficult to find guides, tips and (let's be honest) stackoverflow questions when we got stuck. This was even tougher when it intersected with other difficult things like managing audio while an app is backgrounded. We thankfully were able to troubleshoot with some very helpful Google and Apple engineers that were here over the weekend.

Beyond just communicating between the phone and smartwatch, what's particularly hard is keeping a CPR session synced between the two. There's roughly 0.6 seconds between each compression, so extra care must be taken so that the haptic feedback from the watch matches the audio on the phone. Further, smart watch operating systems are extremely aggressive in process management to save battery life. When a user puts their wrist down and the screen turns off, the app is backgrounded. This means that over any given CPR session, the smart watch app could be backgrounded half a dozen times. Also in general the smart watch SDKs are less feature rich than what we were used to with the respective smart phone SDKs, so that took some getting used to.

##Accomplishments that we're proud of
This was our first time going to a hackathon and trying to make smart watch apps. We're pretty proud about getting working smart watch apps and companion smart phone apps done over the small amount of time. As a team of 2, we really ended up making 4 different apps. It's also cool because we got to make something socially beneficial that could actually help save a life. It's really satisfying to apply what we've learned in school for the greater good.

##What we learned
Hackathons are hard, but rewarding, and a great place to pick up a new technology. We learned that making smart watch apps that communicate with smart phones apps is challenging the first time around, but doable. This experience has shown us that just like with smart phones, there's tons of room for innovation with smart watches.

##What's next for CPsmaRt
CPsmaRt needs some refinements and legal disclaimers, and then will get put on the App Store and Google Play Store.
