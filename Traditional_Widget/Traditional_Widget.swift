//
//  Traditional_Widget.swift
//  Traditional_Widget
//
//  Created by 염성필 on 2023/12/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imageData: UIImage(named: "WidgetImage"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), imageData: UIImage(named: "WidgetImage"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, imageData: UIImage(named: "WidgetImage"))
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let imageData: UIImage?
}

struct Traditional_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Image("WidgetImage")
            .resizable()
            .scaledToFit()

    }
}

struct Traditional_Widget: Widget {
    let kind: String = "Traditional_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Traditional_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Traditional_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Traditional_WidgetEntryView(entry: SimpleEntry(date: Date(), imageData: UIImage(named: "WidgetImage")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
