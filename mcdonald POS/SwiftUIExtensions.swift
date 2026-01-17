//
//  SwiftUIExtensions.swift
//  mcdonald POS
//
//  Created by Jayden on 15/1/2026.
//  SwiftUI Migration - Color and Font extensions
//

import SwiftUI
import UIKit

// MARK: - SwiftUI Color System
extension Color {
    /// 主品牌色 - 麦当劳橙色
    static var primary: Color {
        Color("Primary")
    }
    
    /// 主品牌色 - 深橙色（按下状态）
    static var primaryDark: Color {
        Color("PrimaryDark")
    }
    
    /// 次要强调色 - 金黄色
    static var secondary: Color {
        Color("Secondary")
    }
    
    /// 成功状态色 - 绿色
    static var success: Color {
        Color("Success")
    }
    
    /// 错误状态色 - 红色
    static var error: Color {
        Color("Error")
    }
    
    /// 表面/卡片背景色
    static var surface: Color {
        Color("Surface")
    }
    
    /// 主文字颜色
    static var textPrimary: Color {
        Color("TextPrimary")
    }
    
    /// 次文字颜色
    static var textSecondary: Color {
        Color("TextSecondary")
    }
    
    /// 边框颜色
    static var border: Color {
        Color("Border")
    }
}

// MARK: - SwiftUI Font System
extension Font {
    /// 大标题 (28pt, Bold)
    static var displayLarge: Font {
        .system(size: 28, weight: .bold)
    }
    
    /// 标题 (20pt, Semibold)
    static var displayMedium: Font {
        .system(size: 20, weight: .semibold)
    }
    
    /// 副标题 (16pt, Medium)
    static var displaySmall: Font {
        .system(size: 16, weight: .medium)
    }
    
    /// 正文 (14pt, Regular)
    static var bodyLarge: Font {
        .system(size: 14, weight: .regular)
    }
    
    /// 小字 (12pt, Regular)
    static var bodySmall: Font {
        .system(size: 12, weight: .regular)
    }
    
    /// 按钮文字 (16pt, Bold)
    static var buttonLarge: Font {
        .system(size: 16, weight: .bold)
    }
    
    /// 标签文字 (13pt, Medium)
    static var labelMedium: Font {
        .system(size: 13, weight: .medium)
    }
}

// MARK: - Spacing System
struct Spacing {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - SwiftUI View Modifiers
extension View {
    /// 添加阴影
    func shadow(opacity: Double = 0.2, radius: CGFloat = 4, x: CGFloat = 0, y: CGFloat = 2) -> some View {
        self.shadow(color: Color.black.opacity(opacity), radius: radius, x: x, y: y)
    }
    
    /// 隐藏键盘
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// 抖动动画（用于反馈）
    func shake() -> some View {
        modifier(ShakeModifier())
    }
    
    /// 脉冲动画（用于强调）
    func pulse() -> some View {
        modifier(PulseModifier())
    }
}

// MARK: - Animation Modifiers
struct ShakeModifier: ViewModifier {
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .animation(
                .spring(response: 0.3, dampingFraction: 0.2)
                .repeatCount(3, autoreverses: true),
                value: offset
            )
            .onAppear {
                offset = 10
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    offset = 0
                }
            }
    }
}

struct PulseModifier: ViewModifier {
    @State private var scale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .animation(
                .spring(response: 0.2)
                .repeatCount(1, autoreverses: true),
                value: scale
            )
            .onAppear {
                scale = 1.05
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    scale = 1.0
                }
            }
    }
}
