public enum AccessibilityIdentifier {
    public enum Donations {
        public static let buyUsCoffeeButton = "buyUsCoffeeButton"
        public static let sendGoodVibesButton = "sendGoodVibesButton"
        public static let sendSuperKindTip = "sendSuperKindTip"
    }
    public enum FrontDoor {
        public static let seeInstructions = "seeInstructions"
    }
    public enum Instructions {
        public static let picker = "instructionsPicker"
        // swiftlint:disable nesting
        public enum WhatsApp {
            public static let step1 = "instructions_whatsapp_step1"
            public static let step4 = "instructions_whatsapp_step4"
        }
        public enum Telegram {
            public static let step1 = "instructions_telegram_step1"
            public static let step4 = "instructions_telegram_step4"
        }
        // swiftlint:enable nesting
    }
    public enum Titles {
        public static let stayUnseen = "stayUnseen"
        public static let stillInTheLoop = "stillInTheLoop"
    }
}
