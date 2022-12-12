app <- ShinyDriver$new("../../", loadTimeout = 6.4e4)

app$snapshotInit("initial_load_test", screenshot = FALSE)
app$snapshot()

app$setInputs(navlistPanel = "panel6")
app$snapshot()

app$setInputs(navlistPanel = "panel7")
app$snapshot()

app$setInputs(navlistPanel = "panel8")
app$snapshot()

app$setInputs(navlistPanel = "panel9")

app$snapshot()
