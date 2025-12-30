# Dental Clinic Management - Python UI (No DB connection needed)
# This satisfies Assignment 9 UI requirement

# -----------------------------
# Dummy Data (Simulating Tables)
# -----------------------------
insurance = [
    {"id": 1, "provider": "SunLife", "policy": "SL123"},
    {"id": 2, "provider": "Manulife", "policy": "MN456"}
]

patients = [
    {"id": 1, "name": "Leen Almuti", "insurance": 1},
    {"id": 2, "name": "John Smith", "insurance": 2}
]

staff = [
    {"id": 1, "name": "Dr. Sarah", "specialization": "Dentist"},
    {"id": 2, "name": "Dr. Omar", "specialization": "Orthodontist"}
]

appointments = [
    {"id": 1, "patient": 1, "staff": 1, "status": "Completed"},
    {"id": 2, "patient": 2, "staff": 2, "status": "Scheduled"}
]


# -----------------------------
# Menu Functions
# -----------------------------
def show_insurance():
    print("\n--- Insurance Providers ---")
    for i in insurance:
        print(f"{i['id']} - {i['provider']} (Policy: {i['policy']})")


def show_patients():
    print("\n--- Patients ---")
    for p in patients:
        ins = next((i["provider"] for i in insurance if i["id"] == p["insurance"]), "None")
        print(f"{p['id']} - {p['name']} (Insurance: {ins})")


def show_staff():
    print("\n--- Dental Staff ---")
    for s in staff:
        print(f"{s['id']} - {s['name']} ({s['specialization']})")


def show_appointments():
    print("\n--- Appointments ---")
    for a in appointments:
        patient_name = next(p["name"] for p in patients if p["id"] == a["patient"])
        staff_name = next(s["name"] for s in staff if s["id"] == a["staff"])
        print(f"{a['id']} - {patient_name} with {staff_name} ({a['status']})")


# -----------------------------
# Main Menu
# -----------------------------
def main_menu():
    while True:
        print("\n==============================")
        print(" DENTAL CLINIC - PYTHON UI ")
        print("==============================")
        print("1) View Insurance Providers")
        print("2) View Patients")
        print("3) View Dental Staff")
        print("4) View Appointments")
        print("E) Exit")
        
        choice = input("Choose an option: ").upper()

        if choice == "1":
            show_insurance()
        elif choice == "2":
            show_patients()
        elif choice == "3":
            show_staff()
        elif choice == "4":
            show_appointments()
        elif choice == "E":
            print("Goodbye!")
            break
        else:
            print("Invalid choice. Try again.")


# Run the program
main_menu()
