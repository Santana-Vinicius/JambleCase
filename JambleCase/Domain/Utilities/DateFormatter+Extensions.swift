import Foundation

extension DateFormatter {
    static let iso8601Full: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    static func timeAgo(from dateString: String) -> String {
        guard let date = iso8601Full.date(from: dateString) else {
            return "recently"
        }
        
        let components = Calendar.current.dateComponents(
            [.minute, .hour, .day, .month, .year],
            from: date,
            to: Date()
        )
        
        if let years = components.year, years > 0 {
            return "\(years)y ago"
        }
        
        if let months = components.month, months > 0 {
            return "\(months)mo ago"
        }
        
        if let days = components.day, days > 0 {
            return "\(days)d ago"
        }
        
        if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        }
        
        if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m ago"
        }
        
        return "just now"
    }
    
    static func formatScheduledTime(from dateString: String) -> String {
        guard let date = iso8601Full.date(from: dateString) else {
            return "Soon"
        }
        
        let formatter = DateFormatter()
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "h:mm a"
            return "Today at \(formatter.string(from: date))"
        } else if calendar.isDateInTomorrow(date) {
            formatter.dateFormat = "h:mm a"
            return "Tomorrow at \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = "MMM d, h:mm a"
            return formatter.string(from: date)
        }
    }
    
    static func formatJoinedDate(from dateString: String) -> String {
        guard let date = iso8601Full.date(from: dateString) else {
            return "Recently"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}
