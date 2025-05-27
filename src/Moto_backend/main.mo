import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Array "mo:base/Array";

actor {
  
    stable var couter_id : Nat = 1959189;


    stable var rekordyEntries: [(Nat, Rekord)] = [];
    
    public type Rekord = {
        id: Nat; 
        value: {
            tekst: Text; 
            passx: Text; 
        };
    };
    
    public type Wartosc = {
      tekst : Text;
      passx : Text;
    };
    
    private var rekordyMap = HashMap.HashMap<Nat, Rekord>(
        0, Nat.equal, Hash.hash
    );
    

    public func init() {
        for ((k, v) in rekordyEntries.vals()) {
            rekordyMap.put(k, v);
        };
    };
    
    // Funkcja wywoływana przed stabilizacją kodu

    system func preupgrade() {

        rekordyEntries := Iter.toArray(rekordyMap.entries());
    };


    system func postupgrade() {
    
        rekordyMap := HashMap.fromIter<Nat, Rekord>(
            rekordyEntries.vals(), 
            rekordyEntries.size(), 
            Nat.equal, 
            Hash.hash
        );
    
        rekordyEntries := [];
    };
    
    public func zapiszTekst(text: Text, pass : Text) : async Text {
        if ((text != "") and (pass != "")) {
            let zmienna : Wartosc = { tekst = text; passx = pass };
            couter_id += 3;
            let message_id : Nat = couter_id;
            
            
            dodajRekord(message_id, zmienna);
            return ""#Nat.toText(message_id);
        } else {
            return "Problem with optain message ID";
        }
    };
    
    private func dodajRekord(id: Nat, wartosc: Wartosc) : () {
        let nowyRekord: Rekord = {
            id = id;
            value = wartosc;
        };
        
        rekordyMap.put(id, nowyRekord);
    };
    
    
    public func pobierzRekord(rekordId: Nat, pass : Text): async Text {
        
        switch (rekordyMap.get(rekordId)) {
            case (?rekord) {
                let ps : Text = pass;
                let rc : Text = rekord.value.passx;
                
                if (rc == ps) {
                    let _x = rekord.value.tekst;
                
                    rekordyMap.delete(rekordId);
                    return _x;
                } else {
                    return " Password is not correct for Message ID ";
                }
            };
            case (null) {
                return "This Id is Ivalid or Message was deleted sorry";
            };
        };
    };
    
    
    public func mapToArray() : async [Rekord] {
        return Iter.toArray(Iter.map(rekordyMap.vals(), func (x: Rekord) : Rekord { x }));
    };
    
    
    public func arrayToMap(arr: [Rekord]) : () {
        for (rekord in arr.vals()) {
            rekordyMap.put(rekord.id, rekord);
        };
    };
}
