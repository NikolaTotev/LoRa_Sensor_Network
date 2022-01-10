/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleTimeSeriesChart extends StatelessWidget {


	SimpleTimeSeriesChart();

	@override
	Widget build(BuildContext context) {
		return  charts.TimeSeriesChart(
			_createSampleData(),
			animate: true,
			// Optionally pass in a [DateTimeFactory] used by the chart. The factory
			// should create the same type of [DateTime] as the data provided. If none
			// specified, the default creates local date time.
			dateTimeFactory: const charts.LocalDateTimeFactory(),
		);
	}

	/// Create one series with sample hard coded data.
	static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
		final data = [
			 TimeSeriesSales( DateTime(2017, 9, 19, 1, 12), 5),
			 TimeSeriesSales( DateTime(2017, 9, 19, 1, 30), 25),
			 TimeSeriesSales( DateTime(2017, 9, 19, 2, 0), 100),
			 TimeSeriesSales( DateTime(2017, 9, 19, 2, 15), 75),
		];

		return [
			 charts.Series<TimeSeriesSales, DateTime>(
				id: 'Sales',
				colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
				domainFn: (TimeSeriesSales sales, _) => sales.time,
				measureFn: (TimeSeriesSales sales, _) => sales.sales,
				data: data,
			)
		];
	}
}

/// Sample time series data type.
class TimeSeriesSales {
	final DateTime time;
	final int sales;

	TimeSeriesSales(this.time, this.sales);
}