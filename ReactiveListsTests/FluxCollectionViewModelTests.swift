//
//  FluxCollectionViewModelTests.swift
//  PlanGrid
//
//  Created by Kiefer Aguilar on 2/4/16.
//  Copyright © 2016 PlanGrid. All rights reserved.
//

import PGSharedTestUtils
@testable import ReactiveLists
import ReactiveSwift
import XCTest

class FluxCollectionViewModelTests: XCTestCase {

    private var _collectionViewModel: FluxCollectionViewModel!

    func testDoubleBlankSupplementaryViewModelInitalizer() {
        parameterize(cases: (nil as CGFloat?, nil as CGFloat?), (42, nil), (nil, 43), (42, 43)) {
            let sectionModel = FluxCollectionViewModel.SectionModel(
                cellViewModels: [generateRandomTestCollectionCellViewModel()],
                headerHeight: $0,
                footerHeight: $1)

            XCTAssertEqual(sectionModel.cellViewModels?.count, 1)
            XCTAssertEqual(sectionModel.headerViewModel?.height, $0)
            XCTAssertEqual(sectionModel.footerViewModel?.height, $1)
            XCTAssertNil(sectionModel.headerViewModel?.viewInfo)
            XCTAssertNil(sectionModel.footerViewModel?.viewInfo)
        }
    }

    func testBlankSupplementaryHeaderViewModelInitalizer() {
        parameterize(cases: (nil as CGFloat?, nil as CGFloat?), (42, nil), (nil, 43), (42, 43)) {
            let sectionModel = FluxCollectionViewModel.SectionModel(
                cellViewModels: [generateRandomTestCollectionCellViewModel()],
                headerHeight: $0,
                footerViewModel: TestCollectionViewSupplementaryViewModel(height: $1, viewKind: .footer, sectionLabel: "A"))

            XCTAssertEqual(sectionModel.cellViewModels?.count, 1)
            XCTAssertNil(sectionModel.headerViewModel?.viewInfo)

            XCTAssertEqual(sectionModel.headerViewModel?.height, $0)
            XCTAssertEqual(sectionModel.footerViewModel?.height, $1)

            let viewInfo = sectionModel.footerViewModel?.viewInfo
            XCTAssertTrue(viewInfo?.registrationMethod == .viewClass(FooterView.self))
            XCTAssertEqual(viewInfo?.reuseIdentifier, "reuse_footer+A")
            XCTAssertEqual(viewInfo?.accessibilityFormat.accessibilityIdentifierForSection(84), "access_footer+84")
        }
    }

    func testBlankSupplementaryFooterViewModelInitalizer() {
        parameterize(cases: (nil as CGFloat?, nil as CGFloat?), (42, nil), (nil, 43), (42, 43)) {
            let sectionModel = FluxCollectionViewModel.SectionModel(
                cellViewModels: [generateRandomTestCollectionCellViewModel()],
                headerViewModel: TestCollectionViewSupplementaryViewModel(height: $0, viewKind: .header, sectionLabel: "A"),
                footerHeight: $1)

            XCTAssertEqual(sectionModel.cellViewModels?.count, 1)
            XCTAssertNil(sectionModel.footerViewModel?.viewInfo)

            XCTAssertEqual(sectionModel.headerViewModel?.height, $0)
            XCTAssertEqual(sectionModel.footerViewModel?.height, $1)

            let viewInfo = sectionModel.headerViewModel?.viewInfo
            XCTAssertTrue(viewInfo?.registrationMethod == .viewClass(HeaderView.self))
            XCTAssertEqual(viewInfo?.reuseIdentifier, "reuse_header+A")
            XCTAssertEqual(viewInfo?.accessibilityFormat.accessibilityIdentifierForSection(84), "access_header+84")
        }
    }

    func testDoubleCustomSupplementaryViewModelInitalizer() {
        parameterize(cases: (nil as CGFloat?, nil as CGFloat?), (42, nil), (nil, 43), (42, 43)) {
            let sectionModel = FluxCollectionViewModel.SectionModel(
                cellViewModels: [generateRandomTestCollectionCellViewModel()],
                headerViewModel: TestCollectionViewSupplementaryViewModel(height: $0, viewKind: .header, sectionLabel: "A"),
                footerViewModel: TestCollectionViewSupplementaryViewModel(height: $1, viewKind: .footer, sectionLabel: "A"))

            XCTAssertEqual(sectionModel.cellViewModels?.count, 1)

            XCTAssertEqual(sectionModel.headerViewModel?.height, $0)
            XCTAssertEqual(sectionModel.footerViewModel?.height, $1)

            let headerViewInfo = sectionModel.headerViewModel?.viewInfo
            XCTAssertTrue(headerViewInfo?.registrationMethod == .viewClass(HeaderView.self))
            XCTAssertEqual(headerViewInfo?.reuseIdentifier, "reuse_header+A")
            XCTAssertEqual(headerViewInfo?.accessibilityFormat.accessibilityIdentifierForSection(84), "access_header+84")

            let footerViewInfo = sectionModel.footerViewModel?.viewInfo
            XCTAssertTrue(footerViewInfo?.registrationMethod == .viewClass(FooterView.self))
            XCTAssertEqual(footerViewInfo?.reuseIdentifier, "reuse_footer+A")
            XCTAssertEqual(footerViewInfo?.accessibilityFormat.accessibilityIdentifierForSection(84), "access_footer+84")
        }
    }

    func testSubscripts() {
        let collectionViewModel = FluxCollectionViewModel(sectionModels: [
            FluxCollectionViewModel.SectionModel(
                cellViewModels: nil,
                headerHeight: 42,
                footerHeight: nil),
            FluxCollectionViewModel.SectionModel(
                cellViewModels: [
                    generateRandomTestCollectionCellViewModel("A"),
                    generateRandomTestCollectionCellViewModel("B"),
                    generateRandomTestCollectionCellViewModel("C"),
                ],
                headerHeight: 43,
                footerHeight: nil),
        ])

        XCTAssertNil(collectionViewModel[9]?.headerViewModel?.height)
        XCTAssertEqual(collectionViewModel[0]?.headerViewModel?.height, 42)

        XCTAssertNil(collectionViewModel[path(0, 0)])
        XCTAssertNil(collectionViewModel[path(9, 0)])
        XCTAssertNil(collectionViewModel[path(1, 9)])
        XCTAssertEqual((collectionViewModel[path(1, 0)] as? TestCollectionCellViewModel)?.label, "A")
    }
}