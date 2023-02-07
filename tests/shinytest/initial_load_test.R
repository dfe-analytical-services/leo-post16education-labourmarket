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



app$setInputs("earn_select1" = "Graduates and non-graduates")
app$snapshot()

app$setInputs("earn_subcat" = "SEN status")
app$snapshot()

app$setInputs("earn_picker" = "With statement of SEN")
app$snapshot()

app$setInputs("comparisoncheck" = "Yes")
app$snapshot()

app$setInputs("earn_select1" = "All individuals")
app$snapshot()

app$setInputs("earn_subcat" = "Region of school")
app$snapshot()

app$setInputs("earn_picker" = "East Midlands")
app$snapshot()

app$setInputs("earn_select1" = "Graduates and non-graduates")
app$snapshot()

app$setInputs("earn_subcat" = "Ethnicity major group")
app$snapshot()

app$setInputs("earn_picker" = "White")
app$snapshot()



app$setInputs("activity_select1" = "All individuals")
app$snapshot()

app$setInputs("sub_group_picker" = "Gender")
app$snapshot()

app$setInputs("picker1" = "Male")
app$snapshot()

app$setInputs("activity_select1" = "Non-graduates: level 3 and above and level 2 or below")
app$snapshot()

app$setInputs("sub_group_picker" = "Ethnicity minor group")
app$snapshot()

app$setInputs("picker1" = "White Non-British")
app$snapshot()
