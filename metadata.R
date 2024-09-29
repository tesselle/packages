# Helpers =====
## R-universe API
uni_info <- function(what = c("Package", "Title", "Version", "Description")) {
  api <- httr2::request("https://tesselle.r-universe.dev")
  req <- httr2::req_url_path(api, "/api/packages/")
  resp <- httr2::req_perform(req)
  json <- httr2::resp_body_json(resp)

  pkg <- lapply(X = json, `[`, what)
  pkg <- lapply(pkg, as.data.frame)
  pkg <- do.call(rbind, pkg)
  pkg
}

## GitHub API
gh_infos <- function(what = c("stargazers_count", "forks", "open_issues")) {
  ## Repo infos
  user_repo <- gh::gh(
    endpoint = "/search/repositories",
    q = "user:tesselle topic:r-package",
    .limit = Inf
  )
  items <- user_repo$items
  if (length(items) < 1) return(NULL)
  if (length(items) == 1 && items == "") return(NULL)

  items <- lapply(items, `[`, c("name", what))
  items <- lapply(items, as.data.frame)
  items <- do.call(rbind, items)
  items
}

# Get =====
## Get R-universe data
runiverse <- try(uni_info())
## Get GitHub data
github <- try(gh_infos())

ok <- !inherits(runiverse, "try-error") && !inherits(github, "try-error")
if (ok) {
  ## Merge metadata
  pkg <- merge(runiverse, github, by.x = "Package", by.y = "name",
               all.x = FALSE, all.y = FALSE, sort = FALSE)
  pkg <- pkg[order(pkg$stargazers_count, decreasing = TRUE), ]
  colnames(pkg) <- tolower(colnames(pkg))

  ## Write CSV
  write.csv(pkg, file = "metadata.csv")

  ## Write yaml
  cat(
    yaml::as.yaml(pkg, column.major = FALSE),
    file = "gallery.yml",
    sep = "\n",
    append = FALSE
  )
}
