#!/bin/bash
# Version b0.1.6

if [ $# -lt 2 ]; then
     echo "Usage: $0 <input_image> <site_name>"
     exit 1
fi

input_image="$1"
site_name="$2"
output_dir="$HOME/site-files/attachments/$site_name/favicons"
# Check if the input image file exists
[ ! -f "$input_image" ] && { echo "Error: Input image not found!"; exit 1; }

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Favicon types
favicon_types=("favicon" "apple-touch-icon" "android-icon" "chrome-icon")

# Sizes for all favicon types
sizes=(
     "16x16 32x32 48x48 64x64 128x128 256x256 57x57 60x60 72x72 76x76 96x96 114x114 120x120 144x144 152x152 180x180"   # Regular favicon sizes
     "57x57 60x60 72x72 76x76 114x114 120x120 144x144 152x152"                                                     # Apple Touch Icon sizes
     "36x36 48x48 72x72 96x96 144x144 192x192"                                                                     # Android Icon sizes
     "16x16 32x32 48x48 64x64 128x128 256x256"                                                                     # Chrome Icon sizes
)

# Check if the 'convert' command is available
if ! command -v convert &> /dev/null; then
    echo "Error: 'convert' command not found! Please install ImageMagick."
    exit 1
fi

# Generate favicon.ico
convert "$input_image" -define icon:auto-resize="64,48,32,16" "$output_dir/favicon.ico"

# Generate PNG files for different sizes
for ((i = 0; i < ${#favicon_types[@]}; i++)); do
     type="${favicon_types[i]}"
     type_sizes=(${sizes[i]})

     for size in ${type_sizes[@]}; do
          png_file="$output_dir/$type-$size.png"
          convert "$input_image" -resize "$size" "$png_file"
          png_files="$png_files $png_file"
     done
done

# Get the site directory
site_dir="$HOME/sites/$site_name"

# Check if the site directory exists
[ ! -d "$site_dir" ] && { echo "Error: Site directory not found!"; exit 1; }

# Copy all favicon files to the site directory
ln -s "$output_dir"/* "$site_dir/static/"

# Remove existing symbolic links in the output directory
find "$output_dir" -maxdepth 1 -type l -delete

# Create symbolic links with full paths in the output directory
for png_file in $png_files; do
     ln -sf "$png_file" "$output_dir/"
done

# Run Hugo in the site directory
cd "$site_dir" || exit
hugo

echo "Favicons generated, copied to $site_dir, symbolic links created (overwriting existing links), and Hugo executed in $site_name."
