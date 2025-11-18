import Foundation
import SwiftUI

struct TimerData: Identifiable, Codable {
    let id: UUID
    var targetHour: Double  // 0.0 to 24.0 (supports half hours via decimals)
    var notificationSound: String
    var notificationMessage: String
    var isStrict: Bool  // true = exact time, false = ±15 minutes
    
    init(id: UUID = UUID(), targetHour: Double, notificationSound: String = "default", notificationMessage: String, isStrict: Bool = false) {
        self.id = id
        self.targetHour = targetHour
        self.notificationSound = notificationSound
        self.notificationMessage = notificationMessage
        self.isStrict = isStrict
    }
}

enum NotificationSound: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case bell = "Bell"
    case chime = "Chime"
    case glass = "Glass"
    case horn = "Horn"
    case note = "Note"
    case ping = "Ping"
    case pop = "Pop"
    case pulse = "Pulse"
    case anticipate = "Anticipate"
    case bloom = "Bloom"
    case calypso = "Calypso"
    case fanfare = "Fanfare"
    case ladder = "Ladder"
    case minuet = "Minuet"
    case newsflash = "News Flash"
    case noir = "Noir"
    case sherwood = "Sherwood Forest"
    case spell = "Spell"
    case suspense = "Suspense"
    case telegraph = "Telegraph"
    case tiptoes = "Tiptoes"
    case typewriters = "Typewriters"
    case update = "Update"
    
    var id: String { self.rawValue }
    
    var systemSoundName: String {
        switch self {
        case .default: return "default"
        case .bell: return "bell.caf"
        case .chime: return "chime.caf"
        case .glass: return "glass.caf"
        case .horn: return "horn.caf"
        case .note: return "note.caf"
        case .ping: return "ping.caf"
        case .pop: return "pop.caf"
        case .pulse: return "pulse.caf"
        case .anticipate: return "Anticipate.caf"
        case .bloom: return "Bloom.caf"
        case .calypso: return "Calypso.caf"
        case .fanfare: return "Fanfare.caf"
        case .ladder: return "Ladder.caf"
        case .minuet: return "Minuet.caf"
        case .newsflash: return "News_Flash.caf"
        case .noir: return "Noir.caf"
        case .sherwood: return "Sherwood_Forest.caf"
        case .spell: return "Spell.caf"
        case .suspense: return "Suspense.caf"
        case .telegraph: return "Telegraph.caf"
        case .tiptoes: return "Tiptoes.caf"
        case .typewriters: return "Typewriters.caf"
        case .update: return "Update.caf"
        }
    }
}
