import 'package:canvas_clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clock_helper/model.dart';

const initialData = CustomizationData(
  unit: TemperatureUnit.celsius,
  location: "creativemaybeno's place",
  temperature: 21.5,
  high: 42,
  low: -5,
  condition: WeatherCondition.snowy,
  // todo make this work (currently background is still light when starting up); afterwards change to light
  theme: ThemeMode.dark,
  timeFormat: TimeFormat.standard,
);

class AutomatedCustomizer extends StatefulWidget {
  final ClockModelBuilder builder;

  const AutomatedCustomizer({
    Key key,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  @override
  State createState() => _AutomatedCustomizerState();
}

class _AutomatedCustomizerState extends State<AutomatedCustomizer> {
  ClockModel model;

  ThemeMode _theme;

  ThemeMode get theme => _theme;

  set theme(ThemeMode value) {
    if (value == _theme) return;

    _theme = value;
    update();
  }

  @override
  void initState() {
    super.initState();

    model = ClockModel();

    applyData(initialData);

    model.addListener(update);
  }

  @override
  void dispose() {
    model.dispose();

    super.dispose();
  }

  void update() {
    setState(() {});
  }

  void applyData(CustomizationData data) {
    theme = data.theme;

    model
      ..location = data.location
      ..is24HourFormat = data.timeFormat == TimeFormat.standard
      ..temperature = data.temperature
      ..high = data.high
      ..low = data.low
      ..weatherCondition = data.condition
      ..unit = data.unit;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: theme,
      home: Builder(
        builder: (context) => Container(
          color: Theme.of(context).canvasColor,
          child: Center(
            child: AspectRatio(
              aspectRatio: 5 / 3,
              child: widget.builder(context, model),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomizationData {
  final WeatherCondition condition;

  final double high, low, temperature;

  final String location;

  final ThemeMode theme;

  final TimeFormat timeFormat;

  final TemperatureUnit unit;

  const CustomizationData({
    this.condition,
    this.high,
    this.location,
    this.low,
    this.temperature,
    this.theme,
    this.timeFormat,
    this.unit,
  });

  CustomizationData copyWith(CustomizationData other) {
    return CustomizationData(
      condition: other.condition ?? condition,
      high: other.high ?? high,
      location: other.location ?? location,
      low: other.low ?? low,
      temperature: other.temperature ?? temperature,
      theme: other.theme ?? theme,
      timeFormat: other.timeFormat ?? timeFormat,
      unit: other.unit ?? unit,
    );
  }
}

enum TimeFormat {
  amPm,

  /// Indicates the 24 hour time format.
  ///
  /// This name is obviously controversial,
  /// but I could not think of a better name
  /// because variables cannot start with digits.
  standard,
}