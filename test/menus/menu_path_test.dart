import 'package:flutter_test/flutter_test.dart';
import 'package:overlord/overlord.dart';

void main() {
  group("Menus > menu paths >", () {
    group("empty path > ", () {
      test("is never a sub-path", () {
        expect(
          const MenuPath([]).isSubPathOf(
            const MenuPath(["file", "new", "document"]),
          ),
          isFalse,
        );

        expect(
          const MenuPath([]).isSubPathOf(
            const MenuPath([]),
          ),
          isFalse,
        );
      });

      test("is never a container path", () {
        expect(
          const MenuPath(["file", "new", "document"]).containsPath(
            const MenuPath([]),
          ),
          isFalse,
        );

        expect(
          const MenuPath([]).containsPath(
            const MenuPath([]),
          ),
          isFalse,
        );
      });
    });

    test("identifies container paths", () {
      // Proper sub-path.
      expect(
        const MenuPath(["file", "new", "document"]).containsPath(
          const MenuPath(["file", "new"]),
        ),
        isTrue,
      );

      // A path contains itself.
      expect(
        const MenuPath(["file", "new", "document"]).containsPath(
          const MenuPath(["file", "new", "document"]),
        ),
        isTrue,
      );

      // A path that matches, but stops short of another path, doesn't contain
      // the longer path.
      expect(
        const MenuPath(["file", "new", "document"]).containsPath(
          const MenuPath(["file", "new", "document", "blog"]),
        ),
        isFalse,
      );

      // A path that starts with a match, but then goes down a different path,
      // doesn't contain the other path.
      expect(
        const MenuPath(["file", "new", "document"]).containsPath(
          const MenuPath(["file", "open"]),
        ),
        isFalse,
      );
    });

    test("identifies subpaths", () {
      // Proper sub-path.
      expect(
        const MenuPath(["file", "new"]).isSubPathOf(
          const MenuPath(["file", "new", "document"]),
        ),
        isTrue,
      );

      // A path is a sub-path of itself.
      expect(
        const MenuPath(["file", "new", "document"]).isSubPathOf(
          const MenuPath(["file", "new", "document"]),
        ),
        isTrue,
      );

      // A path that matches, but goes beyond the main path, isn't a sub-path.
      expect(
        const MenuPath(["file", "new", "document", "blog"]).isSubPathOf(
          const MenuPath(["file", "new", "document"]),
        ),
        isFalse,
      );

      // A path that starts with a match, but then goes down a different path,
      // isn't a sub-path.
      expect(
        const MenuPath(["file", "open"]).isSubPathOf(
          const MenuPath(["file", "new", "document"]),
        ),
        isFalse,
      );
    });

    test("appends paths", () {
      expect(
        const MenuPath(["file", "new"]).append("document"),
        const MenuPath(["file", "new", "document"]),
      );

      expect(
        const MenuPath(["file"]).appendAll(["new", "document"]),
        const MenuPath(["file", "new", "document"]),
      );
    });
  });
}
