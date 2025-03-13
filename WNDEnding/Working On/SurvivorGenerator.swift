//
//  SurvivorGenerator.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 10/5/23.
//

import Foundation
struct SurvivorGenerator {
    static let shared = SurvivorGenerator()
    
    func addSurvivors(_ number : Int){
        Stockpile.shared.addSurvivors(survivors: generateSurvivors(number))
    }
    func generateSurvivors(_ number : Int)->[Soul] {
        var generatedRoster = [Soul]()
        for _ in 0..<number {
            generatedRoster.append(generateBio())
        }
        return generatedRoster
    }
    func manifestSurvivor(info : Soul)->PlayerMob{
        return PlayerMob(survivor: info)
    }
   
    func generateRandomSurvivor()->PlayerMob {
        return PlayerMob(survivor: generateBio())
    }
    func generateBio(fam familiar : Bool = true)-> Soul {
        let maleFirstNames = ["Aaron", "Bob", "Charlie", "David", "Ethan", "Frank", "George", "Heidi", "Isaac", "Jack", "Kevin", "Liam", "Michael", "Noah", "Oscar", "Peter", "Quincy", "Steven", "Tom", "Ulysses", "William", "Xander", "Yusuf"]
        let femaleFirstNames = ["Alice", "Bella", "Carlos", "Diana", "Eve", "Fiona", "Grace", "Hannah", "Ivan", "Jasmine", "Kate", "Laura", "Mia", "Nina", "Olivia", "Paula", "Quinn", "Rachel", "Sarah", "Tina", "Ursula", "Vanessa", "Wendy", "Xena", "Yara", "Zoe"]

        let lastNames = ["Anderson", "Brown", "Clark", "Davis", "Evans", "Ford", "Garcia", "Hill", "Ingram", "Jackson", "Kim", "Lee", "Miller", "Nguyen", "Olsen", "Perez", "Quinn", "Reed", "Smith", "Taylor", "Upton", "Vargas", "Walker", "Xu", "Young", "Zhang",
                         "Adams", "Baker", "Carter", "Dixon", "Edwards", "Fisher", "Griffin", "Harris", "Irwin", "Johnson", "King", "Lewis", "Morgan", "Nelson", "Owens", "Phillips", "Quincy", "Roberts", "Stevens", "Turner", "Underwood", "Vaughn", "Watson", "Xavier", "York", "Zimmerman"]

        let childhood = ["Shy", "Inquisitive", "Imaginative", "Scared", "Joyful", "Crafty", "Rich", "Peculiar", "Athletic", "Adventurous", "Artistic", "Studious", "Independent", "Resilient",
                         "Bold", "Curious", "Determined", "Energetic", "Friendly", "Generous", "Humorous", "Intelligent", "Jovial", "Kind", "Loyal", "Meticulous", "Nurturing", "Optimistic", "Patient", "Quiet", "Respectful", "Sincere", "Thoughtful", "Understanding", "Vivacious", "Wise", "Xenial", "Youthful", "Zealous"]

        let occupations = ["University Student", "Police Officer", "Firefighter", "Doctor", "Mechanic", "Activist", "Self Employed", "Patient", "Single Parent", "Scientist", "Engineer", "Teacher", "Soldier", "Artist", "Chef", "Social Worker", "Entrepreneur", "Musician", "Journalist", "Convict", "Teenager", "Entertainer",
                           "Accountant", "Biologist", "Counselor", "Dentist", "Electrician", "Farmer", "Graphic Designer", "Historian", "Interior Designer", "Journalist", "Librarian", "Marketing Specialist", "Nurse", "Optometrist", "Pharmacist", "Quality Analyst", "Receptionist", "Software Developer", "Translator", "Veterinarian", "Web Developer", "X-ray Technician", "Yoga Instructor", "Zoologist"]
        let isMale = Bool.random()
        let randomFirstName = isMale ? maleFirstNames.randomElement()! : femaleFirstNames.randomElement()!
        let randomLastName = lastNames.randomElement()!
        let randomChildhood = childhood.randomElement()!
        let randomOccupation = occupations.randomElement()!
        
        if familiar {
            return Soul(childhood: randomChildhood, currentOccupation : randomOccupation, firstName: randomFirstName, lastName: randomLastName, sex : isMale ? .male : .female)
        }
        else {
            return Soul(childhood: randomChildhood, currentOccupation : randomOccupation, firstName: randomFirstName, lastName: randomLastName, familiarity: .stranger, sex : isMale ? .male : .female)
        }
       
    }
    
    func getTomb(of selectedPerson: Soul) -> String {
        let title = "\(selectedPerson.childhood.lowercased()) \(selectedPerson.currentOccupation.lowercased())"
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        let article = vowels.contains(title.first ?? Character("")) ? "an" : "a"
        let scriptBasic = """
Rest in Peace : \(selectedPerson.name)

Once known as \(article) \(title), now deceased.
"""
        if selectedPerson.familiarity == .newbie {
                    """
            Rest in Peace : \(selectedPerson.name)

            Once known as \(article) \(title). Died before could get to camp.
            """
        }
        return scriptBasic
    }
    func getBiography(of selectedPerson: Soul) -> String {
        let title = "\(selectedPerson.childhood.lowercased()) \(selectedPerson.currentOccupation.lowercased())"
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        let article = vowels.contains(title.first ?? Character("")) ? "an" : "a"
        let scriptBasic = """
Once known as \(article) \(title). Who \(getPronouns(of: selectedPerson).nom) will be now is up to you...
"""
        return scriptBasic
    }
    func getPronouns(of person : Soul) -> (nom : String, acc : String, poss : String) {
        switch person.sex {
        case .male :
            return (nom : "he", acc: "him", poss: "his")
        case .female :
            return (nom : "she", acc: "her", poss: "hers")
        case .unknown :
            return (nom : "they", acc: "them", poss: "their")
        }
    }
}
