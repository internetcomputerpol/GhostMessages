import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Text "mo:base/Text";


actor {
  
    stable var couter_id : Nat = 1959189;
    stable var rekordy: [Rekord] = [];

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

  
    // Funkcja do dodawania rekordu do stabilnej tablicy

   public func zapiszTekst(text: Text, pass : Text) : async Text
{
   if ((text != "") and (pass != "" ))
   {
  
    //let blob : Blob = BobDylan(text);
    let zmienna : Wartosc = { tekst = text; passx = pass };

    couter_id += 3;
    let message_id : Nat = couter_id;
// Następnie wywołaj funkcję dodajRekord
   dodajRekord( message_id, zmienna);
   return ""#Nat.toText(message_id);

   }
   else 
   {
    return "Problem with optain message ID";
   }
};
    




   private func dodajRekord(id: Nat, wartosc: Wartosc) : () {
        let nowyRekord: Rekord = {
            id = id;
            value = wartosc;
        };
        rekordy := Array.append(rekordy, [nowyRekord]);
    };

    // Funkcja do pobrania rekordu na podstawie identyfikatora
    public func pobierzRekord(rekordId: Nat, pass : Text): async Text {

       let rekord = Array.find(rekordy, func(rekord: Rekord): Bool { rekord.id == rekordId });
        
        switch (rekord) {
            case (?rekord) {
            
            let ps : Text = pass;
            let rc : Text = rekord.value.passx;
            
            if (rc == ps )
             {
                         let _x = rekord.value.tekst;
                         rekordy := Array.filter(rekordy, func(r: Rekord): Bool { r.id != rekordId });
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

    

     // Testowo 
    //----------------------------------------------------------------
   // private  func _pobierzWszystkieRekordy(): async [Rekord] {
  //   return rekordy; 
 //   };
}