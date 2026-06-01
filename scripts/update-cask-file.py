import sys
import re

def main():
    if len(sys.argv) < 4:
        print("Usage: python3 update-cask-file.py <version> <sha256> <file_path>")
        sys.exit(1)

    version = sys.argv[1]
    sha256 = sys.argv[2]
    file_path = sys.argv[3]

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Update version string
        content = re.sub(r'version "[^"]+"', f'version "{version}"', content)
        # Update sha256 string
        content = re.sub(r'sha256 "[^"]+"', f'sha256 "{sha256}"', content)

        with open(file_path, "w", encoding="utf-8") as f:
            f.write(content)

        print(f"Successfully updated Cask file {file_path} to version {version} and sha256 {sha256}")
    except Exception as e:
        print(f"Error updating Cask file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
