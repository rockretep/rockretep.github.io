---
filename: banished_parser
title: Banished Parser
subtitle: OCR tool to parse and record data from the game *Banished*
date: 2019 09 01
tags: [Solo, Tool, JS, AI]
confidence: Very likely
mainimage: banished2.png
---

I was contracted to design and develop a tool to help students in a game statistics and data analysis class. Students needed to be able to record data from the game [*Banished*](http://www.shiningrocksoftware.com/game/) ![](/images/banished.png#right#small)



At first I thought this would be a fairly simple task, as *Banished* provides a modding API. I thought I could easily extract information via the API, but it turned out that the game didn't practically allow for this.

My next thought was to try and use the game's save files as a source for the data, since students only needed 'snapshots' of the game state, rather than a continuous stream of data. Unfortunately, the save files were in a binary format, and despite my efforts to crack the format, I couldn't consistently get the pertinent data from the files.

My next option was to scrape the relevant information from from screenshots using OCR (optical character recognition) software. This was a less than desirable option, given the many more steps required to get the data, and the introduction of potential inaccuracy in the data collected.



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

![](/images/banished2.png)

```
function levenshteinDistance(e, t) {
	var n = e.length,
		r = t.length,
		o = createArray(n + 1, r + 1);
	if (0 == n) return r;
	if (0 == r) return n;
	for (i = 0; i <= n; o[i][0] = i++);
	for (j = 0; j <= r; o[0][j] = j++);
	for (i = 1; i <= n; i++)
		for (j = 1; j <= r; j++) {
			let n = t[j - 1] == e[i - 1] ? 0 : 1;
			o[i][j] = Math.min(
				Math.min(o[i - 1][j] + 1, o[i][j-1] + 1), 
				o[i - 1][j - 1] + n)
		}
	return o[n][r]
}
```
