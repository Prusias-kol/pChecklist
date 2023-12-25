script "pChecklist";
notify Coolfood;

void generateNewFile(string target, int firstId, int lastId);
void generateNewFileCustomList(string target, int[] customList);
int totalItemAmount(item x);
void verfiyChecklist(string target);
void printHelp();
void main(string arg);

record listOfItems {
    int first;
    int last;
    int[] list;
};

void main(string arg) {
    string [int] commands = arg.split_string("\\s+");
    for(int i = 0; i < commands.count(); ++i){
        switch(commands[i]) {
            case "help":
                printHelp();
                return;
            //easy adding new item checklists if you don't know how to format the file
            case "generateCustomList":
                print("Supports custom targetLists");
                print("Read the code to understand how to make your own checklists");
                // TO ADD A CUSTOM LIST OF ITEM IDS, uncomment below
                // Replace targetName with your new target name (no spaces) and {1,2,3} with your list of item ids
                // int[] temp = {1,2,3};
                // generateNewFileCustomList("targetname", temp);
                // TO ADD A CONSECUTIVE LIST OF ITEM IDS
                // Replace targetName with your new target name (no spaces) and firstId and lastId with integers for item ids
                // generateNewFile("targetName", firstId, lastId);
                return;
            default:
                verfiyChecklist(commands[i]);
                return;
        }
    }
}

void generateNewFile(string target, int firstId, int lastId) {
    listOfItems [string] itemList;
    file_to_map("data/personalChecklistData.txt", itemList);
    if ((itemList contains target)) {
        print("Target checklist already exists!", "red");
        return;
    }
    listOfItems temp;
    temp.first = firstId;
    temp.last = lastId;
    temp.list = {};
    itemList[target] = temp;
    if (map_to_file(itemList, "data/personalChecklistData.txt"))
        print("File saved successfully.");
    else
        print("Error, file was not saved.");
}
void generateNewFileCustomList(string target, int[] customList) {
    listOfItems [string] itemList;
    file_to_map("data/personalChecklistData.txt", itemList);
    if ((itemList contains target)) {
        print("Target checklist already exists!", "red");
        return;
    }
    listOfItems temp;
    temp.first = -1;
    temp.last = -1;
    temp.list = customList;
    itemList[target] = temp;
    if (map_to_file(itemList, "data/personalChecklistData.txt"))
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
    listOfItems [string] customList;
    file_to_map("data/personalChecklistData.txt", customList);
    if (!(itemList contains target) && !(customList contains target)) {
        print("Target checklist not found!", "red");
        return;
    }
    if (itemList contains target) {
        int first = itemList[target].first;
        int last = itemList[target].last;
        if (first != -1) {
            for (int i = first; i <= last; i++) {
                item it = to_item(i);
                if (it != $item[none]) {
                    if (totalItemAmount(it) == 0) {
                        print ("X " + it + " not found", "red");
                    } else {
                        print ("O " + it + " found!", "green");
                    }
                }
            }
        } else {
            foreach itId in itemList[target].list {
                item it = to_item(itemList[target].list[itId]);
                if (it != $item[none]) {
                    if (totalItemAmount(it) == 0) {
                        print ("X " + it + " not found", "red");
                    } else {
                        print ("O " + it + " found!", "green");
                    }
                }
            }
        }
    } else {
        int first = customList[target].first;
        int last = customList[target].last;
        if (first != -1) {
            for (int i = first; i <= last; i++) {
                item it = to_item(i);
                if (totalItemAmount(it) == 0) {
                    print ("X " + it + " not found", "red");
                } else {
                    print ("O " + it + " found!", "green");
                }
            }
        } else {
            foreach itId in customList[target].list {
                item it = to_item(itId);
                if (totalItemAmount(it) == 0) {
                    print ("X " + it + " not found", "red");
                } else {
                    print ("O " + it + " found!", "green");
                }
            }
        }
    }
}

void printHelp() {
    print_html("To use this script type pChecklist and then a target checklist name.");
    print_html("<b>Example: pChecklist crimbo22</b>");
    print("**********************************");
    print_html("<b>generateCustomList -</b> Also supports making your custom lists but requires code editing. Instructions in the code.");
    print("**********************************");
    print_html("<font color=0000ff><b>Currently Supported Public Checklist targets</b></font>");
    listOfItems [string] itemList;
    file_to_map("data/checklistData.txt", itemList);
    foreach key in itemList {
        print(key);
    }
    print_html("<font color=0000ff><b>Your Custom Checklist targets</b></font>");
    listOfItems [string] customList;
    file_to_map("data/personalChecklistData.txt", customList);
    foreach key in customList {
        print(key);
    }
}
