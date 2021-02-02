---
filename: banished_parser
title: Banished Parser
subtitle: OCR tool to parse and record data from the game *Banished*
date: 2019-09-01
tags: [Solo, Tool, JS, AI]
confidence: Likely
mainimage: banished2.png
---

The working application can be found here:

I was contracted to design and develop a tool to help students in a game statistics and data analysis class. Students needed to be able to record data from the game [*Banished*](http://www.shiningrocksoftware.com/game/).

![][bp1]

At first I thought this would be a fairly simple task, as *Banished* provides a modding API. I thought I could easily extract information via the API, but it turned out that the game didn't practically allow for this.

My next thought was to try and use the game's save files as a source for the data, since students only needed 'snapshots' of the game state, rather than a continuous stream of data. Unfortunately, the save files were in a binary format, and despite my efforts to crack the format, I couldn't consistently get the pertinent data from the files.

My next option was to scrape the relevant information from screenshots using OCR (optical character recognition) software. This was a less than desirable option, due to the many more steps required to get the data, and the introduction of potential inaccuracy in the data collected. However, it was the only option I could think of at that point.

I didn't want to rely on calls to OCR cloud services, like Microsoft Azure or Google Cloud, due to the cost and to have more direct interfacing with the API. I decided to use [tesseract.js](https://tesseract.projectnaptha.com) for OCR, in combination with [OpenCV](https://opencv.org) for pre-processing. Using tesseract.js made the project more maintainable for me and allowed for students to access the tool on a webpage; I didn't want to distribute a multi-platform client to students.

Since this tool has a very specific use-case, I didn't worry about trying to generalize to program to lower the constraints of the input data (widget location, resolution and scale, etc.). However, I still wanted to make the tool as painless to use; it wouldn't be a very good tool if it was difficult to use.

The basic steps of the program from the input game data to output statistics data are as follows:
<br>
```Capture screenshot of game with GUI widget with specified configuration --> upload screenshot to web tool --> pre-process and filter screenshot using OpenCV library --> scan processed image data with tesseract.js library --> post-process text data --> format final text data into JSON for download```

#### Pre-processing

The problem with screenshots from the game is that there is so much variability that I had to account for, or try to constrain. In order to successfully process and parse data from in-game screenshots of *Banished*, there were many hurdles that I needed to consider (or ignore). The pertinent data that the students needed for their statistical analysis is as follows:

- Time _(date/time captured, [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) format)_
- Season _(string, in-game season)_
- Year _(integer, in-game year)_
- Population _(integer quantity)_:
	- Total population
	- Adults
	- Students
	- Children
- Resources _(integer quantity)_:
	- Log
	- Stone
	- Iron
	- Firewood
	- Coal
	- Tool
	- Food
	- Herb
	- Coat
	- Ale
	- Leather

Conveniently all of this information is located in one UI widget/window in the game. So if my program knows where that UI element is positioned in the input screenshot, I can crop out the rest of the image to only include the relevant data.

![][bp3]


```
function processScreenshot(e) {
	let t = cv.imread(e);
	let n = new cv.Mat;
	let r = new cv.Size(
		BASEREGION.width * UPSCALE * BASESCALE,
		BASEREGION.height * UPSCALE * BASESCALE);
	cv.cvtColor(t, t, cv.COLOR_RGBA2GRAY, 0),
	t = t.roi(scaleRect(new cv.Rect(0, 0, 300, 170), BASESCALE)),
	cv.resize(t, t, r, 0, 0, cv.INTER_AREA),
	cv.bilateralFilter(t, n, 11, 12, 12, cv.BORDER_DEFAULT),
	t.delete(),
	cv.threshold(n, n, 122, 255, cv.THRESH_BINARY),
	cv.bitwise_not(n, n),
	cv.medianBlur(n, n, 3),
	cv.imshow("imageOut", n),
	n.delete()
}
```

**WORK IN PROGRESS...**


[bp1]: /images/banished.png#right#small "banished_parser1"
	loading="lazy" option="small right"

[bp2]: /images/banished2.png "banished_parser2"
	loading="lazy" option="medium"

[bp3]: /images/banishedUIexample.png "banished_ui_example"
	loading="lazy" option="small right"
