import Foundation

struct DateHelper {
    static func formatDate(_ date: Date, withFormat format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    static func calculateDaysBetween(_ startDate: Date, _ endDate: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day
    }

    static func isDateInToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
}