# resize and compress images ===
library(magick)
library(pbapply)  # just so we have a progress bar, because this thing takes a while

resize_n_compress <- function(file_in, file_out, xmax = 1920, quality = 0.7, cutoff = 100000) {
  # xmax <- 1920  # y pixel max
  # quality <- 0.7  # passed on to jpeg::writeJPEG()
  # cutoff <- 100000  # files smaller than this will not be touched
  # file_out <- "test.jpg"
  if (file.size(file_in) < cutoff) {  # in this case, just copy file
    if (!(file_in == file_out)) {
      file.copy(from = file_in, to = file_out, overwrite = TRUE)
    }
  } else {# if larger than cutoff
    # magick workflow
    image_raw <- image_read(path = file_in)
    if (image_info(image_raw)["width"] > xmax) {  # only resize if smaller
      image_resized <- image_scale(image = image_raw, geometry = as.character(xmax))
    } else {
      image_resized <- image_raw
    }
    image_write(image = image_resized, path = file_out, format = "jpeg", quality = quality)
  }
}

find_large_files <- function(dir_original, dir_scaled) {
  # function to find all files which actually NEED to be rescaled
  # otherwise we would end up rescaling files all the time, which is pretty bad
  # dir_original <- "static/img/"
  # dir_scaled <- "public/img/"
  all_original <- list.files(path = dir_original, pattern = "\\.jpg$", all.files = FALSE, no.. = TRUE, full.names = FALSE, recursive = TRUE)
  all_scaled <- list.files(path = dir_scaled, pattern = "\\.jpg$", all.files = FALSE, no.. = TRUE, full.names = FALSE, recursive = TRUE)
  equal_sizes <- rank(x = file.size(paste0(dir_original, all_original))) == rank(file.size(paste0(dir_scaled, all_scaled[all_scaled %in% all_original])))
  large_files <- all_original[equal_sizes]
 return(large_files)
}

reduce_large_files <- function(dir_original, dir_scaled, xmax = 1920, quality = 0.7, cutoff = 100000) {
  large_files <- find_large_files(dir_original = dir_original, dir_scaled = dir_scaled)
  pbapply::pboptions(type = "txt")  # other output will not go to terminal
  pblapply(X = large_files, FUN = function(x) {
    resize_n_compress(file_in = paste0(dir_original, x), file_out = paste0(dir_scaled, x), quality = quality, xmax = xmax, cutoff = cutoff)
  })
}

# now let's do this
invisible(reduce_large_files(dir_original = "static/img/", dir_scaled = "public/img/", quality = 0.5))
