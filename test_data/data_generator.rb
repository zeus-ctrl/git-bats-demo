#!/usr/bin/env ruby

# Create NUM_DATA_FILES files, each containing either the word "SUCCESS"
# (three quarters of the time) or "FAILURE" (one quarter of the time).

NUM_DATA_FILES=100

(0...NUM_DATA_FILES).each do |n|
  c = if rand(4)==0 then "FAILURE" else "SUCCESS" end
  File.open("files/output_file_#{n}.txt", "w+") do |f|
    f.puts(c)
  end
end
