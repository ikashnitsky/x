# ..........................................................
# 2026-03-30 -- ikashnitsky.phd
# render and sync quarto docs                -----------
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# ..........................................................

# make sure I copy and update the latest version of the rendered docs to the dev folder

library(tidyverse)
library(fs)
library(quarto)


# sys-prompts -------------------------------------------------------------

quarto_render(input = "x:/gh/ai-tune/sys-prompts/sys-prompts.qmd")
fs::file_copy(
  path = "x:/gh/ai-tune/sys-prompts/sys-prompts.html",
  new_path = "dev/sys-prompts.html",
  overwrite = TRUE
)


# r-pkg-whitelist -------------------------------------------------------------

quarto_render(input = "x:/gh/r-pkg-whitelist/r-pkg-whitelist.qmd")
fs::file_copy(
  path = "x:/gh/r-pkg-whitelist/r-pkg-whitelist.html",
  new_path = "dev/r-pkg-whitelist.html",
  overwrite = TRUE
)


# openspace -------------------------------------------------------------

quarto_render(input = "x:/gh/ai-tune/openspace/openspace.qmd")
fs::file_copy(
  path = "x:/gh/ai-tune/openspace/openspace.html",
  new_path = "dev/openspace-setup.html",
  overwrite = TRUE
)

quarto_render(input = "x:/gh/ai-tune/openspace/openspace-setup.qmd")
fs::file_copy(
  path = "x:/gh/ai-tune/openspace/openspace-setup.html",
  new_path = "dev/openspace-setup.html",
  overwrite = TRUE
)

quarto_render(input = "x:/gh/ai-tune/openspace/openspace-gemini-refactored.qmd")
fs::file_copy(
  path = "x:/gh/ai-tune/openspace/OpenSpace-gemini-refactored.html",
  new_path = "dev/OpenSpace-gemini-refactored.html",
  overwrite = TRUE
)


# 4R/um newsletter --------------------------------------------------------

# a function to wrap each section in callout notes
wrap_sections_in_callouts <- function(
        input_path,
        output_path,
        callout_type = "note",
        collapse     = TRUE
) {
    lines  <- readLines(input_path, warn = FALSE)
    breaks <- c(which(grepl("^# ", lines)), length(lines) + 1L)

    out <- if (breaks[1] > 1L) lines[seq_len(breaks[1] - 1L)] else character()

    collapse_attr <- if (collapse) ' collapse="true"' else ""

    for (i in seq_along(breaks[-length(breaks)])) {
        start <- breaks[i]
        end   <- breaks[i + 1L] - 1L

        title <- sub("^#+ ", "", lines[start])
        body  <- if (end >= start + 1L) lines[seq(start + 1L, end)] else character()

        out <- c(
            out,
            sprintf('::: {.callout-%s%s}', callout_type, collapse_attr),
            sprintf("## %s", title),
            "",
            body,
            "",
            ":::",
            ""
        )
    }

    writeLines(out, output_path)
    invisible(output_path)
}

news <- read_lines("x:/gh/4Rum/newsletter.md", skip = 6) # don't include April eyt
yaml_head <- read_lines("dev/newsletter.qmd", n_max = 14)
# update qmd from the newsletter.md
write_lines(c(yaml_head, news), "dev/newsletter.qmd", append = FALSE)
wrap_sections_in_callouts("dev/newsletter.qmd", "dev/4rum-news.qmd")
quarto_render(input = "dev/4rum-news.qmd")


