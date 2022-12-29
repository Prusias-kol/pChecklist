void testFunc();
void main();

record listOfItems {
    int first;
    int last;
};

void generateNewFile(string target, int firstId, int lastId) {
    listOfItems [string] itemList;
    file_to_map("data/checklistData.txt", itemList);
    if ((itemList contains target)) {
        print("Target checklist already exists!", "red");
        return;
    }
    listOfItems temp;
    temp.first = firstId;
    temp.last = lastId;
    itemList[target] = temp;
    if (map_to_file(itemList, "data/checklistData.txt"))
        print("File saved successfully.");
    else
        print("Error, file was not saved.");
}

int totalItemAmount(item x) {
    return item_amount(x) + closet_amount(x) + display_amount(x) + equipped_amount(x) + shop_amount(x) + storage_amount(x);
}

void verfiyChecklist(string target) {
    listOfItems [string] itemList;
    file_to_map("data/checklistData.txt", itemList);
    if (!(itemList contains target)) {
        print("Target checklist not found!", "red");
        return;
    }
    int first = itemList[target].first;
    int last = itemList[target].last;
    for (int i = first; i <= last; i++) {
        item it = to_item(i);
        if (totalItemAmount(it) == 0) {
            print ("X " + it + " not found", "red");
        } else {
            print ("O " + it + " found!", "green");
        }
    }
}

void printHelp() {
    print_html("<b>To use this script</b> type pChecklist and then a target checklist name. (pChecklist crimbo22)");
    print_html("<b>Currently Supported Checklist targets</b>");
    listOfItems [string] itemList;
    file_to_map("data/checklistData.txt", itemList);
    foreach key in itemList {
        print(key);
    }
}

void main(string arg) {
    string [int] commands = arg.split_string("\\s+");
    for(int i = 0; i < commands.count(); ++i){
        switch(commands[i]) {
            case "help":
                printHelp();
                return;
            //easy adding new item checklists if you don't know how to format the file
            // case "test":
            //     generateNewFile("x", 2, 3);
            //     return;
            default:
                verfiyChecklist("crimbo22");
                return;
        }
    }
}
