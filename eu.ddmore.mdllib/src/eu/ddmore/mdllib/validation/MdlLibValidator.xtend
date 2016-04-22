/*
 * generated by Xtext
 */
package eu.ddmore.mdllib.validation

import eu.ddmore.mdllib.mdllib.BlockDefinition
import eu.ddmore.mdllib.mdllib.EnumValue
import eu.ddmore.mdllib.mdllib.ListTypeDefinition
import eu.ddmore.mdllib.mdllib.MdlLibPackage
import eu.ddmore.mdllib.mdllib.NamedFuncArgs
import eu.ddmore.mdllib.mdllib.SubListTypeDefinition
import eu.ddmore.mdllib.mdllib.TypeDefinition
import java.util.HashSet
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.validation.Check
import eu.ddmore.mdllib.mdllib.StatementTypeDefn
import eu.ddmore.mdllib.mdllib.StatementType

//import org.eclipse.xtext.validation.Check

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class MdlLibValidator extends AbstractMdlLibValidator {

	public static val INCORRECT_TYPE_CLASS = "incorrect.type.class.mdllib.ddmore.eu"
	public static val MALFORMED_TYPE_CLASS = "malformed.type.class.mdllib.ddmore.eu"
	public static val UNUSED_ATT_NAME = "unused.name.attribute.mdllib.ddmore.eu"
	public static val MALFORMED_BLOCK_DEFINITION = "malformed.block.defn.mdllib.ddmore.eu"
	public static val MALFORMED_STATEMENT_DEFINITION = "malformed.type.statement.mdllib.ddmore.eu"

	@Check
	def void checkTypeDefinitionWellFormed(TypeDefinition it) {
		switch(typeClass){
			case LIST,
			case SUBLIST:
				error("Type class '" + typeClass.literal + "' cannot be used in a type definition",
						MdlLibPackage.eINSTANCE.typeDefinition_TypeClass, INCORRECT_TYPE_CLASS)
			case ENUM:
				if(enumArgs == null || enumArgs.isEmpty){
					error("Type class '" + typeClass.literal + "' must have enumerations values defined",
							MdlLibPackage.eINSTANCE.typeDefinition_TypeClass, MALFORMED_TYPE_CLASS)
				}
			default:{}
		}		
	}


	@Check
	def void checkListSignatureComplete(ListTypeDefinition it) {
		val attNames = new HashSet<String>
		attributes.forEach[
			attNames.add(name)
		]
		sigLists.forEach[sl|
			sl.attRefs.forEach[ar|
				attNames.remove(ar.attRef.name)
			]
		]
		for(unusedName : attNames){
			error("Attribute name '" + unusedName + "' is not used in list signature.",
						MdlLibPackage.eINSTANCE.listTypeDefinition_SigLists, UNUSED_ATT_NAME)
		}
	}

	@Check
	def void checkSublistSignatureComplete(SubListTypeDefinition it) {
		val attNames = new HashSet<String>
		attributes.forEach[
			attNames.add(name)
		]
		sigLists.forEach[sl|
			sl.attRefs.forEach[ar|
				attNames.remove(ar.attRef.name)
			]
		]
		for(unusedName : attNames){
			error("Attribute name '" + unusedName + "' is not used in sublist signature.",
						MdlLibPackage.eINSTANCE.subListTypeDefinition_SigLists, UNUSED_ATT_NAME)
		}
	}

	@Check
	def void checkNamedFunctionSignatureComplete(NamedFuncArgs it) {
		val attNames = new HashSet<String>
		arguments.forEach[
			attNames.add(name)
		]
		sigLists.forEach[sl|
			sl.argRefs.forEach[ar|
				attNames.remove(ar.argRef.name)
			]
		]
		for(unusedName : attNames){
			error("Argument name '" + unusedName + "' is not used in named function signature.",
						MdlLibPackage.eINSTANCE.namedFuncArgs_SigLists, UNUSED_ATT_NAME)
		}
	}

	// all should contain the key attribute - DONE
	// all matches should have the same enum type - DONE
	// all key values should have the same type as the key in the list definition 

	@Check
	def void checkListKeyMappingConsistent(BlockDefinition it){
		if(keyAttName != null){
			if(listType == null){
				var TypeDefinition firstValueType = null
				for(lt : listTypeMappings){
					// find key attribute in list type
					val keyAtt = lt.attType.attributes.findFirst[at|
						at.name == keyAttName
					] 
					if(keyAtt == null){
						error("Key '" + keyAttName + "' not found in mapped list definitions.",
									MdlLibPackage.eINSTANCE.blockDefinition_ListTypeMappings, MALFORMED_BLOCK_DEFINITION)
					}
					else{
						if(lt.attDefn.typeDefinition != keyAtt.attType.typeName){
							error("Mapped value '" + lt.attDefn.name +"' must have the same type as the key '"  + keyAttName + "'.",
										MdlLibPackage.eINSTANCE.blockDefinition_ListTypeMappings, MALFORMED_BLOCK_DEFINITION)
						}
					}
					if(firstValueType == null){
						firstValueType = lt.attDefn.typeDefinition
					}
					else if(lt.attDefn.typeDefinition != firstValueType){
						error("Mapped list key values must be of the same type.",
									MdlLibPackage.eINSTANCE.blockDefinition_ListTypeMappings, MALFORMED_BLOCK_DEFINITION)
					}
				}
			}
		}
	}
	
	@Check
	def void checkListKeyConsistentWithDefinition(BlockDefinition it){
		if(keyAttName != null){
			if(listType != null){
				val keyAtt = listType.attributes.findFirst[at|
					at.name == keyAttName
				] 
				if(keyAtt == null){
					error("Key '" + keyAttName + "' not found in list definition.",
								MdlLibPackage.eINSTANCE.blockDefinition_ListTypeMappings, MALFORMED_BLOCK_DEFINITION)
				}
			}
		}
	}
	
	@Check
	def void checkStatementDefinitionWellFormed(StatementTypeDefn it){
		if(isHasRhs && !(stmtType == StatementType.EQN_DEFN || stmtType == StatementType.LIST_DEFN))
			error("This statement type cannot use the '+' modifier.",
						MdlLibPackage.eINSTANCE.statementTypeDefn_HasRhs, MALFORMED_STATEMENT_DEFINITION)
	}
	
	private def TypeDefinition getTypeDefinition(EnumValue it){
		EcoreUtil2.getContainerOfType(eContainer, TypeDefinition)
	}
	
	def void check(){
		
	}

}
