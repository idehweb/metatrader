void SetUpChart(void) {
  long C_CHART_ID = ChartID();
  ChartSetInteger(C_CHART_ID, CHART_COLOR_CANDLE_BEAR, clrRed);
  ChartSetInteger(C_CHART_ID, CHART_COLOR_CHART_DOWN, clrRed);
  ChartSetInteger(C_CHART_ID, CHART_COLOR_CANDLE_BULL, clrGreen);
  ChartSetInteger(C_CHART_ID, CHART_COLOR_CHART_UP, clrGreen);
  ChartSetInteger(C_CHART_ID, CHART_FIRST_VISIBLE_BAR, clrAqua);
  ChartSetInteger(C_CHART_ID, CHART_COLOR_CHART_LINE, clrWhite);
  ChartRedraw();
}