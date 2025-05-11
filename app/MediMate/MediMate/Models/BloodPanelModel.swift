//
//  BloodPanelModel.swift
//  MediMate
//
//  Created by Simon Bestler on 11.05.25.
//

import Foundation

// Define the ValueUnit struct
struct ValueUnit: Codable {
    var value: Double
    var unit: String
}

// MARK: - BloodPanel
struct BloodPanel: Codable {
    var hemoglobin: ValueUnit?
    var hematocrit: ValueUnit?
    var erythrocytes: ValueUnit?
    var leukocytes: ValueUnit?
    var platelets: ValueUnit?
    var mcv: ValueUnit?  // Changed to lowercase to follow Swift convention
    var mch: ValueUnit?  // Changed to lowercase to follow Swift convention
    var mchc: ValueUnit? // Changed to lowercase to follow Swift convention
    var neutrophils: ValueUnit?
    var lymphocytes: ValueUnit?
    var monocytes: ValueUnit?
    var eosinophils: ValueUnit?
    var basophils: ValueUnit?
    var reticulocytes: ValueUnit?
    var crp: ValueUnit? // Changed to lowercase to follow Swift convention


    //Added an initializer
     init(hemoglobin: ValueUnit? = nil, hematocrit: ValueUnit? = nil, erythrocytes: ValueUnit? = nil, leukocytes: ValueUnit? = nil, platelets: ValueUnit? = nil, mcv: ValueUnit? = nil, mch: ValueUnit? = nil, mchc: ValueUnit? = nil, neutrophils: ValueUnit? = nil, lymphocytes: ValueUnit? = nil, monocytes: ValueUnit? = nil, eosinophils: ValueUnit? = nil, basophils: ValueUnit? = nil, reticulocytes: ValueUnit? = nil, crp: ValueUnit? = nil) {
        self.hemoglobin = hemoglobin
        self.hematocrit = hematocrit
        self.erythrocytes = erythrocytes
        self.leukocytes = leukocytes
        self.platelets = platelets
        self.mcv = mcv
        self.mch = mch
        self.mchc = mchc
        self.neutrophils = neutrophils
        self.lymphocytes = lymphocytes
        self.monocytes = monocytes
        self.eosinophils = eosinophils
        self.basophils = basophils
        self.reticulocytes = reticulocytes
        self.crp = crp
    }
}
