import SwiftUI

struct BucketVisualizationWorkspace: View {
    let drill: BucketPlanDrill
    var showsCallouts = false
    var caption: String?

    var body: some View {
        ZStack {
            BucketBlueprintCanvasBackground()

            if let visualProfile = drill.visualProfile {
                BucketDrillVisualFamilyView(profile: visualProfile)
            } else {
                switch drill.id {
                case "driver-gate", "start-line-gate":
                    BucketStartLineVector()
                case "towel-behind", "toe-heel-gate":
                    BucketContactWindowVector()
                case "clock-circle", "par-18":
                    BucketScoringFinishVector()
                case "carry-ladder", "distance-ladder":
                    BucketDistanceLadderVector()
                default:
                    BucketGenericPracticeVector()
                }
            }

            if showsCallouts, !drill.heroCallouts.isEmpty {
                BucketHeroCalloutLayer(callouts: drill.heroCallouts)
            }
        }
        .aspectRatio(4 / 3, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        }
        .overlay(alignment: .bottomLeading) {
            if let caption, !caption.isEmpty {
                BucketHeroCaptionChip(text: caption)
                    .padding(12)
            }
        }
    }
}

struct BucketHeroCallout: Identifiable {
    enum ChipSide {
        case leading
        case trailing
    }

    let label: String
    // Anchored in the unit space of the visual's drawing area (inside its 18pt inset).
    let unitPoint: CGPoint
    let chipSide: ChipSide

    var id: String { label }
}

extension BucketPlanDrill {
    var heroCallouts: [BucketHeroCallout] {
        guard let visualConfig = visualProfile?.visualConfig else { return [] }

        switch visualConfig {
        case .gatePutt:
            return [
                BucketHeroCallout(label: "GATE", unitPoint: CGPoint(x: 0.58, y: 0.555), chipSide: .trailing),
                BucketHeroCallout(label: "BALL", unitPoint: CGPoint(x: 0.50, y: 0.78), chipSide: .trailing),
                BucketHeroCallout(label: "TARGET", unitPoint: CGPoint(x: 0.50, y: 0.22), chipSide: .trailing)
            ]
        case .strikeSpray:
            return [
                BucketHeroCallout(label: "CLUBFACE", unitPoint: CGPoint(x: 0.19, y: 0.35), chipSide: .trailing),
                BucketHeroCallout(label: "CENTER ZONE", unitPoint: CGPoint(x: 0.59, y: 0.52), chipSide: .trailing)
            ]
        case .stepSequence:
            return [
                BucketHeroCallout(label: "START", unitPoint: CGPoint(x: 0.22, y: 0.36), chipSide: .trailing),
                BucketHeroCallout(label: "FINISH", unitPoint: CGPoint(x: 0.78, y: 0.26), chipSide: .leading)
            ]
        case .distanceLadder:
            return [
                BucketHeroCallout(label: "BALL", unitPoint: CGPoint(x: 0.50, y: 0.84), chipSide: .trailing),
                BucketHeroCallout(label: "ZONES", unitPoint: CGPoint(x: 0.27, y: 0.47), chipSide: .trailing)
            ]
        case .upDownChallenge:
            return [
                BucketHeroCallout(label: "CHIP FROM", unitPoint: CGPoint(x: 0.22, y: 0.62), chipSide: .trailing),
                BucketHeroCallout(label: "LANDING", unitPoint: CGPoint(x: 0.52, y: 0.42), chipSide: .leading),
                BucketHeroCallout(label: "HOLE", unitPoint: CGPoint(x: 0.78, y: 0.42), chipSide: .trailing)
            ]
        case .landingSpotClubCompare:
            return [
                BucketHeroCallout(label: "BALL", unitPoint: CGPoint(x: 0.18, y: 0.76), chipSide: .trailing),
                BucketHeroCallout(label: "LANDING SPOT", unitPoint: CGPoint(x: 0.44, y: 0.60), chipSide: .trailing)
            ]
        case .bunkerSplash, .puttingClock, .feetTogetherBalance, .shuffledShotRoutine, .twoClubTempoCompare, .twoBallTakeaway:
            // These configs still render the generic vector, which has nothing to pin.
            return []
        }
    }
}

struct BucketHeroCalloutLayer: View {
    let callouts: [BucketHeroCallout]

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ForEach(callouts) { callout in
                BucketHeroCalloutPin(callout: callout)
                    .position(
                        x: size.width * callout.unitPoint.x,
                        y: size.height * callout.unitPoint.y
                    )
            }
        }
        .padding(18)
        .allowsHitTesting(false)
    }
}

struct BucketHeroCalloutPin: View {
    let callout: BucketHeroCallout

    var body: some View {
        ZStack {
            Circle()
                .stroke(GarageTheme.accentGreen.opacity(0.55), lineWidth: 1)
                .frame(width: 18, height: 18)

            Circle()
                .fill(GarageTheme.accentGreen)
                .frame(width: 7, height: 7)
        }
        .overlay(alignment: callout.chipSide == .trailing ? .leading : .trailing) {
            HStack(spacing: 0) {
                if callout.chipSide == .trailing {
                    connector
                    chip
                } else {
                    chip
                    connector
                }
            }
            .fixedSize()
            .offset(x: callout.chipSide == .trailing ? 18 : -18)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(callout.label.capitalized)
    }

    private var connector: some View {
        Rectangle()
            .fill(GarageTheme.accentGreen.opacity(0.55))
            .frame(width: 10, height: 1)
    }

    private var chip: some View {
        Text(callout.label)
            .font(.system(size: 10, weight: .heavy, design: .monospaced))
            .tracking(0.8)
            .foregroundStyle(.white.opacity(0.92))
            .lineLimit(1)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(.black.opacity(0.55), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(GarageTheme.accentGreen.opacity(0.35), lineWidth: 1)
            }
    }
}

struct BucketHeroCaptionChip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.white.opacity(0.94))
            .lineLimit(2)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.white.opacity(0.14), lineWidth: 1)
            }
    }
}

struct BucketDrillVisualFamilyView: View {
    let profile: BucketDrillVisualProfile

    var body: some View {
        ZStack {
            switch profile.visualConfig {
            case .gatePutt:
                BucketGatePuttVisual()
            case .strikeSpray:
                BucketStrikeSprayVisual()
            case .stepSequence:
                BucketStepSequenceVisual()
            case .distanceLadder:
                BucketProfileDistanceLadderVisual()
            case .upDownChallenge:
                BucketUpDownChallengeVisual()
            case .landingSpotClubCompare:
                BucketLandingSpotClubCompareVisual()
            case .bunkerSplash, .puttingClock, .feetTogetherBalance, .shuffledShotRoutine, .twoClubTempoCompare, .twoBallTakeaway:
                // Dedicated visuals for these configs are intentionally pending.
                BucketGenericPracticeVector()
            }
        }
        .overlay(alignment: .topLeading) {
            BucketVisualProfileBadge(profile: profile)
                .padding(12)
        }
        .accessibilityLabel(profile.accessibilityLabel)
    }
}

struct BucketVisualProfileBadge: View {
    let profile: BucketDrillVisualProfile

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(GarageTheme.accentGreen)
                .frame(width: 6, height: 6)

            Text(profile.environment.rawValue.uppercased())
                .font(.system(size: 10, weight: .heavy, design: .monospaced))
                .tracking(0.8)
                .foregroundStyle(.white.opacity(0.68))
                .lineLimit(1)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(.black.opacity(0.18), in: Capsule())
        .overlay {
            Capsule()
                .stroke(.white.opacity(0.12), lineWidth: 1)
        }
    }
}

struct BucketGatePuttVisual: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let centerX = size.width * 0.50
            let ballY = size.height * 0.78
            let gateY = size.height * 0.57
            let targetY = size.height * 0.22
            let gateHalfWidth = size.width * 0.08
            let laneHalfWidth = size.width * 0.12

            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: centerX - laneHalfWidth, y: ballY))
                    path.addLine(to: CGPoint(x: centerX - laneHalfWidth * 0.55, y: targetY))
                    path.move(to: CGPoint(x: centerX + laneHalfWidth, y: ballY))
                    path.addLine(to: CGPoint(x: centerX + laneHalfWidth * 0.55, y: targetY))
                }
                .stroke(.white.opacity(0.16), style: StrokeStyle(lineWidth: 0.85, lineCap: .round, dash: [5, 7]))

                Path { path in
                    path.move(to: CGPoint(x: centerX, y: ballY - 8))
                    path.addLine(to: CGPoint(x: centerX, y: targetY))
                }
                .stroke(GarageTheme.accentGreen.opacity(0.78), style: StrokeStyle(lineWidth: 1.2, lineCap: .round))

                ForEach([-1, 1], id: \.self) { side in
                    RoundedRectangle(cornerRadius: 1.5, style: .continuous)
                        .fill(.white.opacity(0.84))
                        .frame(width: 5, height: 42)
                        .position(x: centerX + CGFloat(side) * gateHalfWidth, y: gateY)
                }

                BucketLockOnBall(position: CGPoint(x: centerX, y: ballY))

                Circle()
                    .stroke(.white.opacity(0.42), lineWidth: 0.9)
                    .frame(width: 34, height: 34)
                    .position(x: centerX, y: targetY)

                Text("START LINE")
                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                    .tracking(1.0)
                    .foregroundStyle(.white.opacity(0.58))
                    .position(x: centerX, y: gateY + 48)
            }
        }
        .padding(18)
    }
}

struct BucketStrikeSprayVisual: View {
    private let dots: [(CGFloat, CGFloat, CGFloat)] = [
        (0.47, 0.44, 5), (0.52, 0.46, 6), (0.50, 0.52, 5), (0.44, 0.51, 4), (0.58, 0.42, 4), (0.39, 0.58, 3), (0.64, 0.56, 3)
    ]

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let faceWidth = size.width * 0.62
            let faceHeight = size.height * 0.34
            let center = CGPoint(x: size.width * 0.50, y: size.height * 0.52)

            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.white.opacity(0.035))
                    .frame(width: faceWidth, height: faceHeight)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(.white.opacity(0.38), lineWidth: 1)
                    }
                    .position(center)

                ForEach(0..<7, id: \.self) { index in
                    let x = center.x - faceWidth / 2 + faceWidth * dots[index].0
                    let y = center.y - faceHeight / 2 + faceHeight * dots[index].1
                    Circle()
                        .fill(index < 3 ? GarageTheme.accentGreen.opacity(0.82) : .white.opacity(0.42))
                        .frame(width: dots[index].2 * 2, height: dots[index].2 * 2)
                        .position(x: x, y: y)
                }

                Ellipse()
                    .stroke(GarageTheme.accentGreen.opacity(0.70), style: StrokeStyle(lineWidth: 1.1, dash: [5, 5]))
                    .frame(width: faceWidth * 0.28, height: faceHeight * 0.50)
                    .position(center)

                Text("CENTER")
                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                    .tracking(1.0)
                    .foregroundStyle(GarageTheme.accentGreen.opacity(0.82))
                    .position(x: center.x, y: center.y + faceHeight * 0.78)

                Text("HEEL")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.48))
                    .position(x: center.x - faceWidth * 0.34, y: center.y - faceHeight * 0.72)

                Text("TOE")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.48))
                    .position(x: center.x + faceWidth * 0.34, y: center.y - faceHeight * 0.72)
            }
        }
        .padding(18)
    }
}

struct BucketStepSequenceVisual: View {
    private let labels = ["SET", "STEP", "SWING"]

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let positions = [
                CGPoint(x: size.width * 0.22, y: size.height * 0.56),
                CGPoint(x: size.width * 0.50, y: size.height * 0.50),
                CGPoint(x: size.width * 0.78, y: size.height * 0.46)
            ]

            ZStack {
                ForEach(0..<2, id: \.self) { index in
                    BucketArrowLine(start: positions[index], end: positions[index + 1])
                        .stroke(GarageTheme.accentGreen.opacity(0.68), style: StrokeStyle(lineWidth: 1.4, lineCap: .round, lineJoin: .round))
                }

                ForEach(0..<3, id: \.self) { index in
                    let point = positions[index]
                    BucketSequencePhase(index: index + 1, label: labels[index])
                        .position(point)

                    BucketStickFigure(phase: index)
                        .frame(width: size.width * 0.16, height: size.height * 0.24)
                        .position(x: point.x, y: point.y - size.height * 0.18)
                }
            }
        }
        .padding(18)
    }
}

struct BucketArrowLine: Shape {
    let start: CGPoint
    let end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)

        let angle = atan2(end.y - start.y, end.x - start.x)
        let arrowLength: CGFloat = 10
        let left = CGPoint(
            x: end.x - arrowLength * cos(angle - .pi / 6),
            y: end.y - arrowLength * sin(angle - .pi / 6)
        )
        let right = CGPoint(
            x: end.x - arrowLength * cos(angle + .pi / 6),
            y: end.y - arrowLength * sin(angle + .pi / 6)
        )

        path.move(to: left)
        path.addLine(to: end)
        path.addLine(to: right)
        return path
    }
}

struct BucketSequencePhase: View {
    let index: Int
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Text("\(index)")
                .font(.system(size: 14, weight: .heavy, design: .monospaced))
                .foregroundStyle(.black.opacity(0.88))
                .frame(width: 28, height: 28)
                .background(GarageTheme.accentGreen, in: Circle())

            Text(label)
                .font(.system(size: 11, weight: .heavy, design: .monospaced))
                .tracking(0.8)
                .foregroundStyle(.white.opacity(0.72))
        }
    }
}

struct BucketStickFigure: View {
    let phase: Int

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let centerX = size.width / 2
            let head = CGPoint(x: centerX, y: size.height * 0.18)
            let bodyTop = CGPoint(x: centerX, y: size.height * 0.28)
            let bodyBottom = CGPoint(x: centerX + CGFloat(phase - 1) * 5, y: size.height * 0.58)
            let leftFoot = CGPoint(x: bodyBottom.x - size.width * (phase == 1 ? 0.16 : 0.24), y: size.height * 0.86)
            let rightFoot = CGPoint(x: bodyBottom.x + size.width * (phase == 2 ? 0.28 : 0.16), y: size.height * 0.86)

            ZStack {
                Circle()
                    .stroke(.white.opacity(0.54), lineWidth: 1)
                    .frame(width: 12, height: 12)
                    .position(head)

                Path { path in
                    path.move(to: bodyTop)
                    path.addLine(to: bodyBottom)
                    path.move(to: bodyTop)
                    path.addLine(to: CGPoint(x: bodyTop.x - size.width * 0.24, y: size.height * 0.48))
                    path.move(to: bodyTop)
                    path.addLine(to: CGPoint(x: bodyTop.x + size.width * 0.24, y: size.height * 0.48))
                    path.move(to: bodyBottom)
                    path.addLine(to: leftFoot)
                    path.move(to: bodyBottom)
                    path.addLine(to: rightFoot)
                    path.move(to: CGPoint(x: bodyTop.x - size.width * 0.30, y: size.height * 0.36))
                    path.addLine(to: CGPoint(x: bodyTop.x + size.width * 0.34, y: size.height * (phase == 2 ? 0.28 : 0.44)))
                }
                .stroke(.white.opacity(0.54), style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

struct BucketProfileDistanceLadderVisual: View {
    private let zones = ["5 FT", "10 FT", "20 FT", "30 FT"]

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let left = size.width * 0.20
            let right = size.width * 0.80
            let centerX = size.width * 0.50
            let yValues = [size.height * 0.73, size.height * 0.60, size.height * 0.47, size.height * 0.34]

            ZStack {
                ForEach(0..<zones.count, id: \.self) { index in
                    let y = yValues[index]
                    let inset = CGFloat(index) * size.width * 0.035

                    Path { path in
                        path.move(to: CGPoint(x: left + inset, y: y))
                        path.addLine(to: CGPoint(x: right - inset, y: y))
                    }
                    .stroke(index == 0 ? GarageTheme.accentGreen.opacity(0.82) : .white.opacity(0.28), lineWidth: index == 0 ? 1.4 : 0.9)

                    Text(zones[index])
                        .font(.system(size: 12, weight: .heavy, design: .monospaced))
                        .foregroundStyle(index == 0 ? GarageTheme.accentGreen.opacity(0.92) : .white.opacity(0.58))
                        .position(x: centerX, y: y - 17)
                }

                Path { path in
                    path.move(to: CGPoint(x: centerX, y: size.height * 0.84))
                    path.addLine(to: CGPoint(x: centerX, y: size.height * 0.24))
                }
                .stroke(.white.opacity(0.15), style: StrokeStyle(lineWidth: 0.8, dash: [4, 6]))

                BucketLockOnBall(position: CGPoint(x: centerX, y: size.height * 0.84))

                Text("CURRENT")
                    .font(.system(size: 10, weight: .heavy, design: .monospaced))
                    .tracking(0.8)
                    .foregroundStyle(.white.opacity(0.58))
                    .position(x: centerX, y: size.height * 0.91)
            }
        }
        .padding(18)
    }
}

struct BucketUpDownChallengeVisual: View {
    private let labels = ["CHIP", "PUTT", "SCORE"]

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let points = [
                CGPoint(x: size.width * 0.22, y: size.height * 0.62),
                CGPoint(x: size.width * 0.52, y: size.height * 0.42),
                CGPoint(x: size.width * 0.78, y: size.height * 0.42)
            ]

            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.16), lineWidth: 0.9)
                    .frame(width: size.width * 0.48, height: size.height * 0.42)
                    .position(x: size.width * 0.62, y: size.height * 0.43)

                Circle()
                    .stroke(GarageTheme.accentGreen.opacity(0.70), lineWidth: 1.1)
                    .frame(width: 34, height: 34)
                    .position(points[1])

                BucketCrosshairTarget(position: points[2])

                Path { path in
                    path.move(to: points[0])
                    path.addQuadCurve(to: points[1], control: CGPoint(x: size.width * 0.36, y: size.height * 0.22))
                    path.addLine(to: points[2])
                }
                .stroke(GarageTheme.accentGreen.opacity(0.68), style: StrokeStyle(lineWidth: 1.25, lineCap: .round, lineJoin: .round, dash: [6, 5]))

                ForEach(0..<labels.count, id: \.self) { index in
                    BucketScoringNode(index: index + 1, label: labels[index])
                        .position(x: points[index].x, y: points[index].y + size.height * 0.20)
                }
            }
        }
        .padding(18)
    }
}

struct BucketScoringNode: View {
    let index: Int
    let label: String

    var body: some View {
        VStack(spacing: 5) {
            Text("\(index)")
                .font(.system(size: 12, weight: .heavy, design: .monospaced))
                .foregroundStyle(index == 1 ? .black.opacity(0.88) : .white.opacity(0.76))
                .frame(width: 24, height: 24)
                .background(index == 1 ? GarageTheme.accentGreen : .white.opacity(0.08), in: Circle())
                .overlay {
                    Circle()
                        .stroke(.white.opacity(0.16), lineWidth: 1)
                }

            Text(label)
                .font(.system(size: 10, weight: .heavy, design: .monospaced))
                .tracking(0.7)
                .foregroundStyle(.white.opacity(0.70))
        }
    }
}

struct BucketLandingSpotClubCompareVisual: View {
    private let clubs = ["PW", "9I", "7I"]

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let start = CGPoint(x: size.width * 0.18, y: size.height * 0.76)
            let landing = CGPoint(x: size.width * 0.44, y: size.height * 0.48)
            let finishes = [
                CGPoint(x: size.width * 0.64, y: size.height * 0.38),
                CGPoint(x: size.width * 0.74, y: size.height * 0.47),
                CGPoint(x: size.width * 0.84, y: size.height * 0.57)
            ]

            ZStack {
                Circle()
                    .stroke(GarageTheme.accentGreen.opacity(0.82), style: StrokeStyle(lineWidth: 1.2, dash: [5, 4]))
                    .frame(width: 44, height: 44)
                    .position(landing)

                Text("LAND")
                    .font(.system(size: 10, weight: .heavy, design: .monospaced))
                    .tracking(0.8)
                    .foregroundStyle(GarageTheme.accentGreen.opacity(0.86))
                    .position(x: landing.x, y: landing.y - 36)

                ForEach(0..<clubs.count, id: \.self) { index in
                    let finish = finishes[index]
                    Path { path in
                        path.move(to: start)
                        path.addQuadCurve(
                            to: landing,
                            control: CGPoint(x: size.width * 0.26, y: size.height * (0.28 + CGFloat(index) * 0.05))
                        )
                        path.addLine(to: finish)
                    }
                    .stroke(index == 0 ? GarageTheme.accentGreen.opacity(0.78) : .white.opacity(0.28 + Double(index) * 0.10), style: StrokeStyle(lineWidth: 1.1, lineCap: .round, lineJoin: .round))

                    Circle()
                        .fill(index == 0 ? GarageTheme.accentGreen.opacity(0.86) : .white.opacity(0.58))
                        .frame(width: 7, height: 7)
                        .position(finish)

                    Text(clubs[index])
                        .font(.system(size: 10, weight: .heavy, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.68))
                        .position(x: finish.x + 18, y: finish.y)
                }

                BucketLockOnBall(position: start)
            }
        }
        .padding(18)
    }
}

struct BucketBlueprintCanvasBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.006, green: 0.014, blue: 0.012),
                Color(red: 0.018, green: 0.056, blue: 0.036),
                Color(red: 0.006, green: 0.012, blue: 0.010)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct BucketLockOnBall: View {
    let position: CGPoint

    var body: some View {
        Circle()
            .fill(.white.opacity(0.90))
            .frame(width: 7, height: 7)
            .position(x: position.x, y: position.y)
    }
}

struct BucketCrosshairTarget: View {
    let position: CGPoint

    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.42), style: StrokeStyle(lineWidth: 0.75, lineCap: .butt, lineJoin: .miter))
                .frame(width: 17, height: 17)

            Path { path in
                path.move(to: CGPoint(x: -24, y: 8.5))
                path.addLine(to: CGPoint(x: 41, y: 8.5))
                path.move(to: CGPoint(x: 8.5, y: -24))
                path.addLine(to: CGPoint(x: 8.5, y: 41))
            }
            .stroke(.white.opacity(0.36), style: StrokeStyle(lineWidth: 0.75, lineCap: .butt, lineJoin: .miter))
        }
        .frame(width: 17, height: 17)
        .position(x: position.x, y: position.y)
    }
}

struct BucketStartLineVector: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let centerX = size.width / 2
            let topY = size.height * 0.22
            let ballY = size.height * 0.68
            let baseY = size.height * 0.86
            let stickInset = size.width * 0.08
            let gateY = size.height * 0.30
            let notchLength = size.width * 0.045

            ZStack {
                ForEach([-1, 1], id: \.self) { side in
                    Path { path in
                        path.move(to: CGPoint(x: centerX + CGFloat(side) * stickInset, y: topY))
                        path.addLine(to: CGPoint(x: centerX + CGFloat(side) * stickInset, y: baseY))
                    }
                    .stroke(GarageTheme.accentGreen.opacity(0.60), style: StrokeStyle(lineWidth: 1.1, lineCap: .round, lineJoin: .round))
                }

                ForEach([-1, 1], id: \.self) { side in
                    Path { path in
                        let x = centerX + CGFloat(side) * stickInset
                        path.move(to: CGPoint(x: x, y: gateY))
                        path.addLine(to: CGPoint(x: x - CGFloat(side) * notchLength, y: gateY))
                        path.move(to: CGPoint(x: x, y: gateY + size.height * 0.045))
                        path.addLine(to: CGPoint(x: x - CGFloat(side) * notchLength, y: gateY + size.height * 0.045))
                    }
                    .stroke(.white.opacity(0.70), style: StrokeStyle(lineWidth: 0.95, lineCap: .round, lineJoin: .round))
                }

                BucketLockOnBall(position: CGPoint(x: centerX, y: ballY))
            }
        }
        .padding(18)
    }
}

struct BucketContactWindowVector: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let towel = CGRect(
                x: size.width * 0.23,
                y: size.height * 0.57,
                width: size.width * 0.54,
                height: size.height * 0.18
            )
            let ball = CGPoint(x: towel.midX, y: towel.minY - 12)

            ZStack {
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .stroke(GarageTheme.accentGreen.opacity(0.70), style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round, dash: [4, 5]))
                    .frame(width: towel.width, height: towel.height)
                    .position(x: towel.midX, y: towel.midY)

                BucketLockOnBall(position: ball)
            }
        }
        .padding(14)
    }
}

struct BucketScoringFinishVector: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let aimPoint = CGPoint(x: size.width * 0.50, y: size.height * 0.50)

            ZStack {
                BucketCrosshairTarget(position: aimPoint)
            }
        }
        .padding(14)
    }
}

struct BucketDistanceLadderVector: View {
    private let zones = ["5 FT", "10 FT", "20 FT", "30 FT"]

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let centerX = size.width / 2
            let laneLeft = size.width * 0.24
            let laneRight = size.width * 0.76
            let yValues = [
                size.height * 0.72,
                size.height * 0.58,
                size.height * 0.45,
                size.height * 0.33
            ]

            ZStack {
                ForEach(0..<zones.count, id: \.self) { index in
                    let y = yValues[index]
                    let inset = CGFloat(index) * size.width * 0.045

                    Path { path in
                        path.move(to: CGPoint(x: laneLeft + inset, y: y))
                        path.addLine(to: CGPoint(x: laneRight - inset, y: y))
                    }
                    .stroke(GarageTheme.accentGreen.opacity(0.56), style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))

                    Text(zones[index])
                        .font(.system(size: 13, weight: .heavy, design: .monospaced))
                        .foregroundStyle(.white.opacity(index == 0 ? 0.88 : 0.66))
                        .position(x: centerX, y: y - 16)
                }

                ForEach([-1, 1], id: \.self) { side in
                    Path { path in
                        path.move(to: CGPoint(x: centerX + CGFloat(side) * size.width * 0.28, y: size.height * 0.78))
                        path.addLine(to: CGPoint(x: centerX + CGFloat(side) * size.width * 0.14, y: size.height * 0.25))
                    }
                    .stroke(.white.opacity(0.58), style: StrokeStyle(lineWidth: 1.1, lineCap: .round, lineJoin: .round))
                }

                ForEach([-1, 0, 1], id: \.self) { offset in
                    BucketLockOnBall(position: CGPoint(x: centerX + CGFloat(offset) * 34, y: size.height * 0.82))
                }

                Circle()
                    .stroke(.white.opacity(0.62), style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                    .frame(width: 44, height: 12)
                    .position(x: centerX, y: size.height * 0.22)
            }
        }
        .padding(18)
    }
}

struct BucketGenericPracticeVector: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                ForEach(0..<4, id: \.self) { index in
                    let y = size.height * (0.30 + CGFloat(index) * 0.14)
                    Path { path in
                        path.move(to: CGPoint(x: size.width * 0.28, y: y))
                        path.addLine(to: CGPoint(x: size.width * 0.72, y: y))
                    }
                    .stroke(.white.opacity(0.16), style: StrokeStyle(lineWidth: 0.75, lineCap: .butt, lineJoin: .miter, dash: [3, 7]))
                }

                Path { path in
                    path.move(to: CGPoint(x: size.width * 0.50, y: size.height * 0.22))
                    path.addLine(to: CGPoint(x: size.width * 0.50, y: size.height * 0.78))
                    path.move(to: CGPoint(x: size.width * 0.24, y: size.height * 0.50))
                    path.addLine(to: CGPoint(x: size.width * 0.76, y: size.height * 0.50))
                }
                .stroke(.white.opacity(0.30), style: StrokeStyle(lineWidth: 0.75, lineCap: .butt, lineJoin: .miter))
            }
        }
        .padding(18)
    }
}
