/// Timeseries chart example

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:lora_flutter_client/ProjectDataModels/ApiModel_SensorReadingEntry.dart';
import 'package:lora_flutter_client/ProjectDataModels/ChartModel_TimeSeries.dart';
import 'package:lora_flutter_client/backend/StationDataModel.dart';
import 'package:provider/provider.dart';

import '../backend/SensorDataModel.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
	SimpleTimeSeriesChart(this.stationID);

	String stationID;

	@override
	Widget build(BuildContext context) {
		return
			Consumer<StationDataModel>(
				builder: (context, dataModel, child) {
					return charts.TimeSeriesChart(
						_createSampleData(dataModel.chartData),
						animate: true,
						primaryMeasureAxis: charts.NumericAxisSpec(
								tickProviderSpec:
								charts.BasicNumericTickProviderSpec(desiredTickCount: 10)),
						// Optionally pass in a [DateTimeFactory] used by the chart. The factory
						// should create the same type of [DateTime] as the data provided. If none
						// specified, the default creates local date time.
						dateTimeFactory: const charts.LocalDateTimeFactory(),);
				},
			);
	}

	/// Create one series with sample hard coded data.
	static List<charts.Series<TimeSeries, DateTime>> _createSampleData(List<TimeSeries> data) {
		return [
			charts.Series<TimeSeries, DateTime>(
				id: 'Sales',
				colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
				domainFn: (TimeSeries sales, _) => sales.time,
				measureFn: (TimeSeries sales, _) => sales.dataPoint,
				data: data,
			)
		];
	}
}
