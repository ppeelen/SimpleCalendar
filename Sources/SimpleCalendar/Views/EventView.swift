//
//  SwiftUIView.swift
//  
//
//  Created by Paul Peelen on 2023-09-09.
//

import SwiftUI

struct EventView: View {
    let event: any CalendarEventRepresentable
    let selectionAction: SelectionAction
    
    // For opening Event details
    @State private var showEventSheet = false
    
    var body: some View {
        VStack {
            if case .destination(let customView) = selectionAction {
                NavigationLink {
                    AnyView(customView(event))
                } label: {
                    content
                }
            } else {
                content
                    .onTapGesture {
                        switch selectionAction {
                        case .sheet, .customSheet:
                            showEventSheet = true
                        case .inform(let closure):
                            closure(event)
                        default:
                            break
                        }
                    }
                    .sheet(isPresented: $showEventSheet) {
                        ZStack {
                            if case .customSheet(let customView) = selectionAction {
                                AnyView(customView(event))
                            } else {
                                EventDetailsView(event: event)
                            }
                        }
                        .presentationDetents([.medium])
                    }
            }
        }
    }
    
    private var content: some View {
        let mainColor = event.activity.type.color
        let endDate = event.startDate.addingTimeInterval(event.activity.duration)
        
        return VStack {
            VStack(alignment: .leading) {
                if (event.activity.duration / 60) <= 30 {
                    if event.columnCount > 0 {
                        HStack(alignment: .center) {
                            Text(event.activity.title)
                                .foregroundColor(mainColor)
                                .font(.caption)
                                .padding(.top, 4)
                                .fontWeight(.semibold)
                                .dynamicTypeSize(.small ... .large)
                            Spacer()
                            Text("\(event.startDate.formatted(date: .omitted, time: .shortened)), \(Int(event.activity.duration / 60)) min")
                                .foregroundColor(mainColor)
                                .font(.caption2)
                                .dynamicTypeSize(.small ... .large)
                        }
                    } else {
                        HStack(alignment: .center) {
                            Text(event.activity.title)
                                .foregroundColor(mainColor)
                                .font(.caption)
                                .padding(.top, 4)
                                .fontWeight(.semibold)
                                .dynamicTypeSize(.small ... .large)
                            Spacer()
                            Text("\(event.startDate.formatted(date: .omitted, time: .shortened)) - \(endDate.formatted(date: .omitted, time: .shortened)), \(Int(event.activity.duration / 60)) min")
                                .foregroundColor(mainColor)
                                .font(.caption2)
                                .dynamicTypeSize(.small ... .large)
                        }
                    }
                } else if (event.activity.duration / 60) <= 60 {
                    Text(event.activity.title)
                        .foregroundColor(mainColor)
                        .font(.caption)
                        .padding(.top, 4)
                        .fontWeight(.semibold)
                        .dynamicTypeSize(.small ... .large)
                    if event.columnCount > 0 {
                        Text("\(event.startDate.formatted(date: .omitted, time: .shortened)), \(Int(event.activity.duration / 60)) min")
                            .foregroundColor(mainColor)
                            .font(.caption2)
                            .dynamicTypeSize(.small ... .large)
                    } else {
                        Text("\(event.startDate.formatted(date: .omitted, time: .shortened)) - \(endDate.formatted(date: .omitted, time: .shortened)), \(Int(event.activity.duration / 60)) min")
                            .foregroundColor(mainColor)
                            .font(.caption2)
                            .dynamicTypeSize(.small ... .large)
                    }
                } else {
                    Text(event.activity.title)
                        .foregroundColor(mainColor)
                        .font(.caption)
                        .padding(.top, 4)
                        .fontWeight(.semibold)
                        .dynamicTypeSize(.small ... .large)
                    Text("\(event.startDate.formatted(date: .omitted, time: .shortened)) - \(endDate.formatted(date: .omitted, time: .shortened))")
                        .foregroundColor(mainColor)
                        .font(.caption2)
                        .dynamicTypeSize(.small ... .large)
                    Text("Duration: \(Int(event.activity.duration / 60)) min")
                        .foregroundColor(mainColor)
                        .font(.caption2)
                        .dynamicTypeSize(.small ... .large)
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .background(mainColor.opacity(0.30), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                HStack {
                    Rectangle()
                        .fill(mainColor)
                        .frame(maxHeight: .infinity, alignment: .leading)
                        .frame(width: 4)
                    Spacer()
                }
            }
        }
        .foregroundColor(.primary)
        .overlay {
            RoundedRectangle(cornerRadius: 6)
                .stroke(mainColor, lineWidth: 1)
                .frame(maxHeight: .infinity)
        }
        .mask(
            RoundedRectangle(cornerRadius: 6)
                .frame(maxHeight: .infinity)
        )
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        let activity15min = CalendarActivity.forPreview(duration: 60 * 15)
        let activity30min = CalendarActivity.forPreview(duration: 60 * 30)
        let activity60min = CalendarActivity.forPreview(duration: 60 * 60)
        
        let event15 = CalendarEvent.forPreview(activity: activity15min)
        let event30 = CalendarEvent.forPreview(activity: activity30min)
        let event60 = CalendarEvent.forPreview(activity: activity60min)
        
        Group {
            EventView(event: event15, selectionAction: .none)
                .previewDisplayName("Normal 15min")
            EventView(event: event15, selectionAction: .none)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .previewDisplayName("XXXL 15min")
            EventView(event: event15, selectionAction: .none)
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("XS 15min")
            EventView(event: event30, selectionAction: .none)
                .previewDisplayName("Normal 30min")
            EventView(event: event30, selectionAction: .none)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .previewDisplayName("XXXL 30min")
            EventView(event: event30, selectionAction: .none)
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("XS 30min")
            EventView(event: event60, selectionAction: .none)
                .previewDisplayName("Normal 60min")
            EventView(event: event60, selectionAction: .none)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .previewDisplayName("XXXL 60min")
            EventView(event: event60, selectionAction: .none)
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("XS 60min")
        }
    }
}
