import 'dart:async';
import 'dart:io';

class UIUtils {
  static const String reset = '\x1B[0m';
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';
  static const String brightBlack = '\x1B[90m';
  static const String brightRed = '\x1B[91m';
  static const String brightGreen = '\x1B[92m';
  static const String brightYellow = '\x1B[93m';
  static const String brightBlue = '\x1B[94m';
  static const String brightMagenta = '\x1B[95m';
  static const String brightCyan = '\x1B[96m';
  static const String brightWhite = '\x1B[97m';

  static const String horizontalLine = '─';
  static const String verticalLine = '│';
  static const String topLeftCorner = '┌';
  static const String topRightCorner = '┐';
  static const String bottomLeftCorner = '└';
  static const String bottomRightCorner = '┘';
  static const String cross = '┼';
  static const String tUp = '┴';
  static const String tDown = '┬';
  static const String tLeft = '┤';
  static const String tRight = '├';

  static void clearScreen() {
    if (Platform.isWindows) {
      print(Process.runSync('cls', [], runInShell: true).stdout);
    } else {
      print(Process.runSync('clear', [], runInShell: true).stdout);
    }
  }

  static String colorize(String text, String color) {
    return '$color$text$reset';
  }

  static void printHeader(String title) {
    final width = 50;
    final padding = (width - title.length - 2) ~/ 2;
    final leftPadding = padding;
    final rightPadding = width - title.length - 2 - leftPadding;

    print(colorize(topLeftCorner + horizontalLine * (width - 2) + topRightCorner, brightBlue));
    print(colorize(verticalLine + ' ' * leftPadding + title + ' ' * rightPadding + verticalLine, brightBlue));
    print(colorize(bottomLeftCorner + horizontalLine * (width - 2) + bottomRightCorner, brightBlue));
  }

  static void printMenu(List<String> options) {
    final width = 50;
    print(colorize(topLeftCorner + horizontalLine * (width - 2) + topRightCorner, brightBlue));

    for (var i = 0; i < options.length; i++) {
      final option = '${i + 1}. ${options[i]}';
      final padding = width - option.length - 2;
      print(colorize(verticalLine + ' ' + option + ' ' * padding + verticalLine, brightBlue));
    }

    print(colorize(bottomLeftCorner + horizontalLine * (width - 2) + bottomRightCorner, brightBlue));
  }

  static void printSuccess(String message) {
    print(colorize('✓ $message', brightGreen));
  }

  static void printError(String message) {
    print(colorize('✗ $message', brightRed));
  }

  static void printWarning(String message) {
    print(colorize('⚠ $message', brightYellow));
  }

  static void printInfo(String message) {
    print(colorize('ℹ $message', brightCyan));
  }

  static void printTable(List<String> headers, List<List<String>> rows) {
    final columnWidths = List<int>.filled(headers.length, 0);

    for (var i = 0; i < headers.length; i++) {
      columnWidths[i] = headers[i].length;
      for (var row in rows) {
        if (row[i].length > columnWidths[i]) {
          columnWidths[i] = row[i].length;
        }
      }
      columnWidths[i] += 2;
    }

    String topBorder = colorize(topLeftCorner, brightBlue);
    for (var i = 0; i < headers.length; i++) {
      topBorder += colorize(horizontalLine * columnWidths[i], brightBlue);
      if (i < headers.length - 1) {
        topBorder += colorize(tDown, brightBlue);
      }
    }
    topBorder += colorize(topRightCorner, brightBlue);
    print(topBorder);

    String headerLine = colorize(verticalLine, brightBlue);
    for (var i = 0; i < headers.length; i++) {
      final padding = columnWidths[i] - headers[i].length;
      final leftPadding = padding ~/ 2;
      final rightPadding = padding - leftPadding;
      headerLine += ' ' * leftPadding + headers[i] + ' ' * rightPadding + colorize(verticalLine, brightBlue);
    }
    print(headerLine);

    String separator = colorize(tRight, brightBlue);
    for (var i = 0; i < headers.length; i++) {
      separator += colorize(horizontalLine * columnWidths[i], brightBlue);
      if (i < headers.length - 1) {
        separator += colorize(cross, brightBlue);
      }
    }
    separator += colorize(tLeft, brightBlue);
    print(separator);

    for (var row in rows) {
      String rowLine = colorize(verticalLine, brightBlue);
      for (var i = 0; i < row.length; i++) {
        final padding = columnWidths[i] - row[i].length;
        final leftPadding = padding ~/ 2;
        final rightPadding = padding - leftPadding;
        rowLine += ' ' * leftPadding + row[i] + ' ' * rightPadding + colorize(verticalLine, brightBlue);
      }
      print(rowLine);
    }

    String bottomBorder = colorize(bottomLeftCorner, brightBlue);
    for (var i = 0; i < headers.length; i++) {
      bottomBorder += colorize(horizontalLine * columnWidths[i], brightBlue);
      if (i < headers.length - 1) {
        bottomBorder += colorize(tUp, brightBlue);
      }
    }
    bottomBorder += colorize(bottomRightCorner, brightBlue);
    print(bottomBorder);
  }

  static String? getInput(String prompt, {bool required = true, String? defaultValue}) {
    while (true) {
      if (defaultValue != null) {
        print(colorize('$prompt (padrão: $defaultValue): ', brightCyan));
      } else {
        print(colorize('$prompt: ', brightCyan));
      }

      final input = stdin.readLineSync()?.trim();

      if (input == null || input.isEmpty) {
        if (defaultValue != null) {
          return defaultValue;
        }
        if (!required) {
          return null;
        }
        printError('Entrada inválida. Por favor, tente novamente.');
        continue;
      }

      return input;
    }
  }

  static int? getNumericInput(String prompt, {bool required = true, int? defaultValue, int? min, int? max}) {
    while (true) {
      if (defaultValue != null) {
        print(colorize('$prompt (padrão: $defaultValue): ', brightCyan));
      } else {
        print(colorize('$prompt: ', brightCyan));
      }

      final input = stdin.readLineSync()?.trim();

      if (input == null || input.isEmpty) {
        if (defaultValue != null) {
          return defaultValue;
        }
        if (!required) {
          return null;
        }
        printError('Entrada inválida. Por favor, tente novamente.');
        continue;
      }

      try {
        final value = int.parse(input);

        if (min != null && value < min) {
          printError('O valor deve ser maior ou igual a $min.');
          continue;
        }

        if (max != null && value > max) {
          printError('O valor deve ser menor ou igual a $max.');
          continue;
        }

        return value;
      } catch (e) {
        printError('Por favor, insira um número válido.');
        continue;
      }
    }
  }

  static void showLoading(String message) {
    final frames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
    var frameIndex = 0;

    stdout.write(colorize('${frames[frameIndex]} $message', brightCyan));

    Timer.periodic(Duration(milliseconds: 100), (timer) {
      stdout.write('\r');
      frameIndex = (frameIndex + 1) % frames.length;
      stdout.write(colorize('${frames[frameIndex]} $message', brightCyan));
    });
  }

  static void stopLoading() {
    stdout.write('\r');
    stdout.write(' ' * 100);
    stdout.write('\r');
  }
}