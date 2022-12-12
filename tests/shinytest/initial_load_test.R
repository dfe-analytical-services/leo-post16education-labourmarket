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



app$setInputs(input_id="earn_select1")
app$snapshot()

app$setInputs(input_id="earn_subcat")
app$snapshot()

app$setInputs(input_id="earn_picker")
app$snapshot()

app$setInputs(input_id="comparisoncheck")
app$snapshot()

app$setInputs(input_id="activity_select1")
app$snapshot()

app$setInputs(input_id="sub_group_picker")
app$snapshot()

app$setInputs(input_id="picker1")
app$snapshot()