library(shiny)

tabPanelOne <- function() {
  return (
    shiny::tabPanel(
      "Select Type",
      value = "panel1",
      gov_layout(
        size = "full",
        heading_text("Page 1",
                     size = "l"),
        label_hint(
          "label1",
          "These are some examples of the types of user\n                   select type inputs that you can use"
        ),
        heading_text("radio_button_Input", size = "s"),
        radio_button_Input(
          inputId = "name_changed",
          label = "Have you changed your name?",
          choices = c("Yes",
                      "No"),
          inline = TRUE,
          hint_label = "This includes changing your last name or spelling\n                            your name differently."
        ),
        heading_text("checkbox_Input", size = "s"),
        checkbox_Input(
          inputId = "checkID",
          cb_labels = c(
            "Waste from animal carcasses",
            "Waste from mines or quarries",
            "Farm or agricultural waste"
          ),
          checkboxIds = c("op1", "op2", "op3"),
          label = "Which types of waste do you transport?",
          hint_label = "Select all that apply."
        ),
        heading_text("select_Input", size = "s"),
        select_Input(
          inputId = "sorter",
          label = "Sort by",
          select_text = c(
            "Recently published",
            "Recently updated",
            "Most views",
            "Most comments"
          ),
          select_value = c("published",
                           "updated", "view", "comments")
        ),
        heading_text("file_Input",
                     size = "s"),
        file_Input(inputId = "file1",
                   label = "Upload a file"),
        heading_text("button_Input",
                     size = "s"),
        button_Input("btn1", "Go to next page")
      )
    )
  )
}