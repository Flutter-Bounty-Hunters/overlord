import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class MultiLevelMenuController with ChangeNotifier {
  MenuPath? get activePath => _activePath;
  MenuPath? _activePath;

  bool isActive(MenuPath menuPath) {
    if (_activePath == null) {
      return false;
    }

    return menuPath.isSubPathOf(_activePath!);
  }

  void activate(MenuPath menuPath) {
    if (_visiblePath == null || !menuPath.isSubPathOf(_visiblePath!)) {
      debugPrint("WARNING: Can't activate path because it's not a sub-path of the visible path.");
      debugPrint(" - desired active path: ${menuPath.serialize()}");
      debugPrint(" - visible path: ${_visiblePath?.serialize()}");
      return;
    }

    _activePath = menuPath;
    notifyListeners();
  }

  MenuPath? get visiblePath => _visiblePath;
  MenuPath? _visiblePath;

  bool isVisible(MenuPath menuPath) {
    if (_visiblePath == null) {
      return false;
    }

    return menuPath.isSubPathOf(_visiblePath!);
  }

  void show(MenuPath menuPath) {
    _visiblePath = menuPath;
    notifyListeners();
  }

  void close() {
    _visiblePath = null;
    notifyListeners();
  }
}

class MenuPath {
  const MenuPath(this._path);

  List<String> get components => List.from(_path);
  final List<String> _path;

  bool containsPath(MenuPath other) {
    if (other._path.isEmpty) {
      // An empty path has no meaning, so we always say that an empty path
      // isn't a sub-path of any other path.
      return false;
    }

    if (other._path.length > _path.length) {
      return false;
    }

    for (int i = 0; i < other._path.length; i += 1) {
      if (_path[i] != other._path[i]) {
        return false;
      }
    }

    return true;
  }

  bool isSubPathOf(MenuPath other) {
    if (_path.isEmpty) {
      // An empty path has no meaning, so we always say that an empty path
      // isn't a sub-path of any other path.
      return false;
    }

    if (_path.length > other._path.length) {
      return false;
    }

    for (int i = 0; i < _path.length; i += 1) {
      if (_path[i] != other._path[i]) {
        return false;
      }
    }

    return true;
  }

  MenuPath append(String component) => MenuPath([..._path, component]);

  MenuPath appendAll(List<String> components) => MenuPath([..._path, ...components]);

  String serialize() => _path.join(" > ");

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuPath &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(_path, other._path);

  @override
  int get hashCode => _path.hashCode;
}
