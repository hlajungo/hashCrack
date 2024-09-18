#include <fstream>
#include <future>
#include <iostream>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

// Mutex for synchronizing file access
std::mutex output_mutex;

// Function to process a range of lines and store in buffer
void
process_lines (const std::vector<std::string> &lines,
               std::vector<std::string> &buffer, int length_threshold)
{
  for (const auto &line : lines)
    {
      if (line.size () >= length_threshold)
        {
          buffer.push_back (line); // Store the result in the buffer
        }
    }
}

int
main (int argc, char *argv[])
{
  //too less argument
  if (argc < 4)
    {
      std::cerr << "Usage: " << argv[0]
                << " <input_file> <output_file> <length_threshold>\n";
      return 1;
    }

  std::string input_file_path = argv[1];
  std::string output_file_path = argv[2];
  int length_threshold = std::stoi (argv[3]);

  std::ifstream input_file (input_file_path);
  if (!input_file.is_open ())
    {
      std::cerr << "Failed to open input file.\n";
      return 1;
    }

  std::vector<std::string> lines;
  std::string line;
  while (std::getline (input_file, line))
    {
      lines.push_back (line);
    }

  input_file.close ();

  // Number of threads for parallel processing
  const unsigned int num_threads = std::thread::hardware_concurrency ();
  std::vector<std::future<void> > futures;

  // Split the lines between threads
  size_t lines_per_thread = lines.size () / num_threads;
  std::vector<std::vector<std::string> > buffers (
      num_threads); // Buffer for each thread

  for (unsigned int i = 0; i < num_threads; ++i)
    {
      size_t start = i * lines_per_thread;
      size_t end = (i == num_threads - 1) ? lines.size ()
                                          : (i + 1) * lines_per_thread;

      // Each thread processes a chunk of lines and stores in its own buffer
      futures.push_back (
          std::async (
          std::launch::async,
          [start,
          end,
          &lines,
          &buffers,
          length_threshold,
          i] {
            process_lines (std::vector<std::string> (lines.begin () + start,
                                                     lines.begin () + end),
                           buffers[i], length_threshold);
          }));
    }

  // Wait for all threads to complete
  for (auto &future : futures)
    {
      future.get ();
    }

  // Write the results from all buffers to the output file (synchronized)
  std::ofstream output_file (output_file_path, std::ios::app);
  if (!output_file.is_open ())
    {
      std::cerr << "Failed to open output file.\n";
      return 1;
    }

  for (const auto &buffer : buffers)
    {
      std::lock_guard<std::mutex> lock (
          output_mutex); // Ensure that only one thread writes at a time
      for (const auto &result_line : buffer)
        {
          output_file << result_line << std::endl;
        }
    }

  output_file.close ();
  std::cout << "Processing completed.\n";
  return 0;
}
