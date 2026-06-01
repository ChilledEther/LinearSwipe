import re
import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 update-version.py <version>")
        sys.exit(1)

    new_version = sys.argv[1]
    pbxproj_path = "LinearSwipe.xcodeproj/project.pbxproj"

    try:
        with open(pbxproj_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Regular expression to match MARKETING_VERSION lines and update the version
        updated_content = re.sub(
            r'(MARKETING_VERSION\s*=\s*)[^;]+;',
            rf'\g<1>{new_version};',
            content
        )

        with open(pbxproj_path, "w", encoding="utf-8") as f:
            f.write(updated_content)

        print(f"Successfully updated MARKETING_VERSION to {new_version} in {pbxproj_path}")
    except Exception as e:
        print(f"Error updating version: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
